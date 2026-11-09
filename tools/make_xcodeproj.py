from pathlib import Path
import hashlib

root = Path(__file__).resolve().parents[1]
sources = sorted((root / "ZuZu").rglob("*.swift"))


def uid(value: str) -> str:
    return hashlib.sha1(value.encode()).hexdigest()[:24].upper()


def entry(identifier: str, content: str) -> str:
    return f"\t\t{uid(identifier)} = {{ {content.rstrip('; ')}; }};"


file_refs = []
build_files = []
source_entries = []
groups = []
for folder in ("App", "Core"):
    folder_sources = [p for p in sources if p.parent.name == folder]
    children = " ".join(f"{uid('file:' + str(p.relative_to(root)))} /* {p.name} */," for p in folder_sources)
    groups.append(entry("group:" + folder, f"isa = PBXGroup; children = ( {children} ); path = {folder}; sourceTree = \"<group>\""))
    for path in folder_sources:
        relative = str(path.relative_to(root))
        file_refs.append(entry("file:" + relative, f"isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {path.name}; sourceTree = \"<group>\""))
        build_files.append(entry("build:" + relative, f"isa = PBXBuildFile; fileRef = {uid('file:' + relative)} /* {path.name} */"))
        source_entries.append(f"{uid('build:' + relative)} /* {path.name} */,")

project = uid("project")
target = uid("target")
main_group = uid("main_group")
zuzu_group = uid("zuzu_group")
products_group = uid("products_group")
product_ref = uid("product")
hero_ref = uid("hero_ref")
hero_build = uid("hero_build")
resources_group = uid("resources_group")
sources_phase = uid("sources_phase")
resources_phase = uid("resources_phase")
frameworks_phase = uid("frameworks_phase")
project_configs = uid("project_configs")
target_configs = uid("target_configs")
project_debug = uid("project_debug")
project_release = uid("project_release")
target_debug = uid("target_debug")
target_release = uid("target_release")

content = f'''// !$*UTF8*$!
{{
 archiveVersion = 1;
 classes = {{}};
 objectVersion = 56;
 objects = {{
/* Begin PBXBuildFile section */
{chr(10).join(build_files)}
{entry('hero_build', f'isa = PBXBuildFile; fileRef = {hero_ref} /* CompletionHero.png */')}
/* End PBXBuildFile section */
/* Begin PBXFileReference section */
{chr(10).join(file_refs)}
{entry('hero_ref', 'isa = PBXFileReference; lastKnownFileType = image.png; path = CompletionHero.png; sourceTree = "<group>"')}
{entry('product', 'isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = ZuZu.app; sourceTree = BUILT_PRODUCTS_DIR')}
/* End PBXFileReference section */
/* Begin PBXGroup section */
{entry('main_group', f'isa = PBXGroup; children = ( {zuzu_group} /* ZuZu */, {products_group} /* Products */, ); sourceTree = "<group>"')}
{entry('zuzu_group', f'isa = PBXGroup; children = ( {uid("group:App")} /* App */, {uid("group:Core")} /* Core */, {resources_group} /* Resources */, ); path = ZuZu; sourceTree = "<group>"')}
{entry('resources_group', f'isa = PBXGroup; children = ( {hero_ref} /* CompletionHero.png */, ); path = Resources; sourceTree = "<group>"')}
{chr(10).join(groups)}
{entry('products_group', f'isa = PBXGroup; children = ( {product_ref} /* ZuZu.app */, ); name = Products; sourceTree = "<group>"')}
/* End PBXGroup section */
/* Begin PBXNativeTarget section */
{entry('target', f'isa = PBXNativeTarget; buildConfigurationList = {target_configs}; buildPhases = ( {sources_phase}, {frameworks_phase}, {resources_phase}, ); buildRules = ( ); dependencies = ( ); name = ZuZu; productName = ZuZu; productReference = {product_ref}; productType = "com.apple.product-type.application"')}
/* End PBXNativeTarget section */
/* Begin PBXProject section */
{entry('project', f'isa = PBXProject; attributes = {{ LastUpgradeCheck = 2640; TargetAttributes = {{ {target} = {{ CreatedOnToolsVersion = 26.4; }}; }}; }}; buildConfigurationList = {project_configs}; compatibilityVersion = "Xcode 14.0"; developmentRegion = en; hasScannedForEncodings = 0; knownRegions = ( en, Base, ); mainGroup = {main_group}; productRefGroup = {products_group}; projectDirPath = ""; projectRoot = ""; targets = ( {target}, )')}
/* End PBXProject section */
/* Begin PBXSourcesBuildPhase section */
{entry('sources_phase', f'isa = PBXSourcesBuildPhase; buildActionMask = 2147483647; files = ( {" ".join(source_entries)} ); runOnlyForDeploymentPostprocessing = 0')}
/* End PBXSourcesBuildPhase section */
/* Begin PBXFrameworksBuildPhase section */
{entry('frameworks_phase', 'isa = PBXFrameworksBuildPhase; buildActionMask = 2147483647; files = ( ); runOnlyForDeploymentPostprocessing = 0')}
/* End PBXFrameworksBuildPhase section */
/* Begin PBXResourcesBuildPhase section */
{entry('resources_phase', f'isa = PBXResourcesBuildPhase; buildActionMask = 2147483647; files = ( {hero_build} /* CompletionHero.png */, ); runOnlyForDeploymentPostprocessing = 0')}
/* End PBXResourcesBuildPhase section */
/* Begin XCBuildConfiguration section */
{entry('project_debug', 'isa = XCBuildConfiguration; buildSettings = { CLANG_ENABLE_MODULES = YES; SWIFT_VERSION = 5.0; IPHONEOS_DEPLOYMENT_TARGET = 17.0; SDKROOT = iphoneos; }; name = Debug')}
{entry('project_release', 'isa = XCBuildConfiguration; buildSettings = { CLANG_ENABLE_MODULES = YES; SWIFT_VERSION = 5.0; IPHONEOS_DEPLOYMENT_TARGET = 17.0; SDKROOT = iphoneos; }; name = Release')}
{entry('target_debug', 'isa = XCBuildConfiguration; buildSettings = { ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES; CODE_SIGN_STYLE = Automatic; CURRENT_PROJECT_VERSION = 1; GENERATE_INFOPLIST_FILE = YES; INFOPLIST_KEY_NSCameraUsageDescription = "ZuZu uses the front camera to count pushups on this iPhone."; IPHONEOS_DEPLOYMENT_TARGET = 17.0; MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.gaplesslabs.ZuZu; PRODUCT_NAME = "$(TARGET_NAME)"; SUPPORTED_PLATFORMS = "iphoneos iphonesimulator"; SWIFT_VERSION = 5.0; TARGETED_DEVICE_FAMILY = 1; }; name = Debug')}
{entry('target_release', 'isa = XCBuildConfiguration; buildSettings = { ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES; CODE_SIGN_STYLE = Automatic; CURRENT_PROJECT_VERSION = 1; GENERATE_INFOPLIST_FILE = YES; INFOPLIST_KEY_NSCameraUsageDescription = "ZuZu uses the front camera to count pushups on this iPhone."; IPHONEOS_DEPLOYMENT_TARGET = 17.0; MARKETING_VERSION = 1.0; PRODUCT_BUNDLE_IDENTIFIER = com.gaplesslabs.ZuZu; PRODUCT_NAME = "$(TARGET_NAME)"; SUPPORTED_PLATFORMS = "iphoneos iphonesimulator"; SWIFT_VERSION = 5.0; TARGETED_DEVICE_FAMILY = 1; }; name = Release')}
/* End XCBuildConfiguration section */
/* Begin XCConfigurationList section */
{entry('project_configs', f'isa = XCConfigurationList; buildConfigurations = ( {project_debug}, {project_release}, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release')}
{entry('target_configs', f'isa = XCConfigurationList; buildConfigurations = ( {target_debug}, {target_release}, ); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release')}
/* End XCConfigurationList section */
 }};
 rootObject = {project};
}}
'''

project_dir = root / "ZuZu.xcodeproj"
project_dir.mkdir(exist_ok=True)
(project_dir / "project.pbxproj").write_text(content)
print(project_dir)
