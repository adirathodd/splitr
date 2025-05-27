//
//  TextRecognitionService.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//


import Foundation
import UIKit
import Vision

/// Wraps Vision text-recognition in a throwing API.
final class TextRecognitionService {
    /// Recognize text lines from scanned pages.
    /// - Parameter images: Scanned pages of a receipt.
    /// - Returns: An array of text lines.
    func recognizeTextLines(from images: [UIImage]) throws -> [String] {
        var allLines: [String] = []

        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        for image in images {
            guard let cgImage = image.cgImage else { continue }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])

            // Extract observations as VNRecognizedTextObservation
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                continue
            }

            for textObs in observations {
                if let candidate = textObs.topCandidates(1).first {
                    allLines.append(candidate.string)
                }
            }
        }

        return allLines
    }
}

