//
//  ViewController.swift
//  iosdc2018-livecoding
//
//  Created by Masatoshi Kubode on 2018/08/09.
//  Copyright © 2018 Wantedly. All rights reserved.
//

import UIKit
import Then
import SnapKit
import UITextView_Placeholder

class ViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [TweetViewController()]
    }
}

class TweetViewController: UIViewController {
    private let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.done, target: nil, action: nil)
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let textView = UITextView().then {
        $0.placeholder = "いまどうしてる？"
    }
    private let remainsLabel = UILabel().then {
        $0.text = "10/140"
        $0.textAlignment = .right
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = tweetButton
        navigationController?.navigationBar.backgroundColor = .white
        view.addSubview(stackView.then {
            $0.addArrangedSubview(textView)
            $0.addArrangedSubview(remainsLabel)
        })
        stackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

