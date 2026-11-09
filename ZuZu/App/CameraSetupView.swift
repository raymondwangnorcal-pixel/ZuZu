import AVFoundation
import SwiftUI

struct CameraSetupView: View {
    @EnvironmentObject private var workout: WorkoutController
    @State private var permission: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    private var cameraAvailable: Bool { CameraPoseTracker.hasFrontCamera }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
            HStack {
                Button { workout.discard() } label: { Image(systemName: "xmark") }
                    .accessibilityLabel("Close setup")
                Spacer()
                Text("CAMERA SETUP")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(ZuZuTheme.muted)
                Spacer()
                Image(systemName: "xmark").hidden()
            }
            .padding(.top, 12)

            VStack(alignment: .leading, spacing: 10) {
                Text("Let’s count together")
                    .font(.system(size: 34, weight: .bold))
                Text("Set your iPhone about 3 feet away on the floor. Fit your upper body and arms in the frame.")
                    .foregroundStyle(ZuZuTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 28).fill(ZuZuTheme.card)
                VStack(spacing: 16) {
                    Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                        .font(.system(size: 72, weight: .ultraLight))
                        .foregroundStyle(ZuZuTheme.blue)
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 70, weight: .ultraLight))
                        .foregroundStyle(ZuZuTheme.amber)
                    Text("Keep your whole upper body visible")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(ZuZuTheme.muted)
                }
                .padding()
            }
            .frame(maxHeight: 310)

            Label("Camera frames are processed on this iPhone only.", systemImage: "lock.shield")
                .font(.footnote)
                .foregroundStyle(ZuZuTheme.muted)

            if !cameraAvailable {
                Text("This iPhone has no available front camera. You can still track pushups with tap counting.")
                    .font(.subheadline)
                    .foregroundStyle(ZuZuTheme.amber)
            } else if permission == .denied || permission == .restricted {
                Text("Camera access is off. Enable it in Settings or use tap counting.")
                    .font(.subheadline)
                    .foregroundStyle(ZuZuTheme.coral)
                Button("Open Settings") {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }
                .buttonStyle(.bordered)
            }

            Button {
                if permission == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { allowed in
                        DispatchQueue.main.async {
                            permission = AVCaptureDevice.authorizationStatus(for: .video)
                            if allowed { workout.begin(mode: .camera) }
                        }
                    }
                } else if permission == .authorized {
                    workout.begin(mode: .camera)
                }
            } label: {
                Text("Start with camera")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.black)
            .background(ZuZuTheme.amber, in: RoundedRectangle(cornerRadius: 17))
            .disabled(!cameraAvailable || permission == .denied || permission == .restricted)

            Button("Use tap counting") { workout.begin(mode: .tap) }
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 20)
        }
        .background(ZuZuTheme.background)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            permission = AVCaptureDevice.authorizationStatus(for: .video)
        }
    }
}
