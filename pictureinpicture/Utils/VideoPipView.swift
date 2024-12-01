//
//  VideoPipView.swift
//  Picture-In-Picture
//
//  Created by Chayan on 26/11/24.
//

import UIKit
import AVFoundation
import AVKit

class VideoPipView: UIView {

    var isEnablePreview: Bool = true {
        didSet {
            previewView.isHidden = !isEnablePreview
        }
    }
    
    lazy var backgroundView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    lazy var displayView: VideoRenderView = {
        let view = VideoRenderView()
        view.backgroundColor = UIColor.darkGray
        view.headView.text = "Chayan Mistry"
        view.headView.isHidden = false
        return view
    }()
    
    lazy var previewView: VideoRenderView = {
        let view = VideoRenderView()
        view.backgroundColor = UIColor.black
        view.headView.text = "Borno"
        view.headView.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        view.headView.isHidden = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
        addSubview(displayView)
        addSubview(previewView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        backgroundView.frame = bounds
        displayView.frame = bounds
        previewView.frame = CGRect(x: Int(bounds.size.width * 0.65), y: 10, width: Int(bounds.size.width * 0.3), height: Int((bounds.size.width * 0.3)) * 16 / 9)
    }
}

class VideoRenderView: UIView {
    
    var displayLayer: AVSampleBufferDisplayLayer?

    lazy var displayView: UIView = {
        let view = UIView()
        displayLayer = AVSampleBufferDisplayLayer()
        displayLayer?.videoGravity = .resizeAspect
        view.layer.addSublayer(displayLayer!)
        return view
    }()
    
    lazy var headView: PipHeadView = {
        let view = PipHeadView()
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headView)
        addSubview(displayView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        displayView.frame = bounds
        displayLayer?.frame = displayView.bounds
        let headW: CGFloat = 0.4 * bounds.width
        let headH: CGFloat = 0.4 * bounds.width
        headView.frame = CGRect(x: (bounds.width - headW) / 2, y: (bounds.height - headH) * 0.5, width: headW, height: headH)
    }
}

class PipHeadView: UIView {
    
    var font: UIFont? {
        didSet {
            guard let font = font else { return }
            self.headLabel.font = font
        }
    }
    
    var text: String? {
        didSet {
            guard let text = text else { return }
            if text.count > 0 {
                let firstStr: String = String(text[text.startIndex])
                self.headLabel.text = firstStr
            }
        }
    }

    lazy var headLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(red: 0.89, green: 0.68, blue: 0.03, alpha: 1)
        return label
    }()
    
    lazy var headImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.headLabel)
        self.addSubview(self.headImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.headLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.headLabel.layer.masksToBounds = true
        self.headLabel.layer.cornerRadius = self.frame.size.width * 0.5
        self.headImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.headImageView.layer.masksToBounds = true
        self.headImageView.layer.cornerRadius = self.frame.size.width * 0.5
    }
}

