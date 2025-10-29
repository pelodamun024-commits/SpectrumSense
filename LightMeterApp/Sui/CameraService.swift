// Core/Services/CameraService.swift

import Foundation
import AVFoundation
import Combine
import UIKit

class CameraService: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Published Properties
    
    @Published var luxValue: Double = 0.0
    
    // MARK: - Private Properties
    
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.lightmeter.sessionQueue")
    @Published var averageColor: UIColor = .clear
    @Published var permissionStatus: AVAuthorizationStatus = .notDetermined

    
    // MARK: - Initialization
    
    override init() {
        super.init()
        // Настраиваем камеру при создании сервиса
        checkPermissions()
        sessionQueue.async {
            self.setupCaptureSession()
        }
    }
    
    // MARK: - Public Methods
    
    
    
    func startSession() {
            // <-- ПРОВЕРЯЕМ РАЗРЕШЕНИЯ ПЕРЕД ЗАПУСКОМ
            checkPermissions()
            guard permissionStatus == .authorized else {
                print("Camera access is not authorized.")
                return
            }
            
            sessionQueue.async {
                if !self.session.isRunning {
                    self.session.startRunning()
                }
            }
        }
    
    func stopSession() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    private func checkPermissions() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.permissionStatus = .authorized
            case .notDetermined:
                // Запрашиваем разрешение
                sessionQueue.suspend() // Приостанавливаем очередь, пока пользователь решает
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    self.permissionStatus = granted ? .authorized : .denied
                    self.sessionQueue.resume()
                }
            default:
                // .denied или .restricted
                self.permissionStatus = .denied
            }
        }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    
    // Этот метод вызывается для каждого кадра видео
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            // --- Логика для luxValue (остается без изменений) ---
            if let metadata = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate) as? [String: Any],
               let exifData = metadata[kCGImagePropertyExifDictionary as String] as? [String: Any],
               let brightnessValue = exifData[kCGImagePropertyExifBrightnessValue as String] as? Double {
                
                let lux = pow(2, brightnessValue) * 10
                
                DispatchQueue.main.async {
                    self.luxValue = lux
                }
            }
            
            // --- Новая логика для определения среднего цвета ---
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            let ciImage = CIImage(cvPixelBuffer: imageBuffer)
            
            // Уменьшаем изображение для быстрой обработки
            let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)])!
            let outputImage = filter.outputImage!
            
            var bitmap = [UInt8](repeating: 0, count: 4)
            let context = CIContext(options: [.workingColorSpace: kCFNull!])
            
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
            
            let avgColor = UIColor(red: CGFloat(bitmap[0]) / 255.0,
                                   green: CGFloat(bitmap[1]) / 255.0,
                                   blue: CGFloat(bitmap[2]) / 255.0,
                                   alpha: CGFloat(bitmap[3]) / 255.0)
            
            DispatchQueue.main.async {
                self.averageColor = avgColor
            }
        }
    
    // MARK: - Private Setup
    
    private func setupCaptureSession() {
        // 1. Начинаем конфигурацию сессии
        session.beginConfiguration()
        session.sessionPreset = .low // Нам не нужно высокое качество видео, только метаданные
        
        // 2. Находим заднюю камеру
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Не удалось найти заднюю камеру")
            session.commitConfiguration()
            return
        }
        
        // 3. Создаем входной поток данных с камеры
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Не удалось создать входной поток с камеры")
            session.commitConfiguration()
            return
        }
        
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        }
        
        // 4. Создаем выходной поток для обработки видеокадров
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        // 5. Завершаем конфигурацию
        session.commitConfiguration()
    }
}
