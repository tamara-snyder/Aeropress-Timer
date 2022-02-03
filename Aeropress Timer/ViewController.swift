//
//  ViewController.swift
//  Aeropress Timer
//
//  Created by Tamara Snyder on 2/1/22.
//

import UIKit
import AVFoundation

extension Double {
  func asString() -> String {
	let formatter = DateComponentsFormatter()
	formatter.allowedUnits = [.minute, .second]
	  formatter.unitsStyle = .positional
	  return formatter.string(from: self) ?? ""
  }
}

class ViewController: UIViewController {
	
	@IBOutlet weak var timerDisplay: UILabel!
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var progressBar: UIProgressView!
	
	var timer = Timer()
	var firstTimer = 150
	var secondTimer = 180
	var isRunning = false
	var player: AVAudioPlayer?
	
	@IBAction func startTimer(_ sender: UIButton) {
		timer.invalidate()
		
		if !isRunning {
			timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
			UIApplication.shared.isIdleTimerDisabled = true
			
			sender.setImage(UIImage(systemName: "pause.circle"), for: .normal)
			sender.tintColor = #colorLiteral(red: 0.2166073918, green: 0.07333020121, blue: 0.3374919295, alpha: 1)
			
			isRunning = true
		} else {
			stopTimer()
		}
	}
	
	@objc func updateTimer() {
		if firstTimer > 0 {
			firstTimer -= 1
			timerDisplay.text = Double(firstTimer).asString()
			progressBar.progress += 1 / Float(340)
		} else if firstTimer == 0 {
			firstTimer -= 1
			playSound()
			timerDisplay.text = "Swirl!"
			progressBar.progress += 1 / Float(340)
		} else if secondTimer > 0 {
			secondTimer -= 1
			timerDisplay.text = Double(secondTimer).asString()
			progressBar.progress += 1 / Float(340)
		} else {
			timerDisplay.text = "Press!"
			stopTimer()
			self.playSound()
			let seconds = 4.0
			DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
				self.timer.invalidate()
				reset()
			}
		}
	}
	
	@IBAction func resetTimer(_ sender: Any) {
		reset()
	}
	
	func reset() {
		timer.invalidate()
		stopTimer()
		firstTimer = 150
		secondTimer = 180
		progressBar.progress = 0
		timerDisplay.text = "2:30"
	}
	
	func stopTimer() {
		isRunning = false
		startButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
		startButton.tintColor = #colorLiteral(red: 0.2166073918, green: 0.07333020121, blue: 0.3374919295, alpha: 1)
		UIApplication.shared.isIdleTimerDisabled = false
	}
	
	func playSound() {
		guard let url = Bundle.main.url(forResource: "bell", withExtension: "wav") else { return }

		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)

			player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)


			guard let player = player else { return }

			player.play()

		} catch let error {
			print(error.localizedDescription)
		}
	}
}
