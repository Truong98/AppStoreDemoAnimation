//
//  CardDetailViewController.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 4/3/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

let text = " Swift 5.1 now makes it easier to create and share binary frameworks with others. It also includes features that make it easier to design better APIs and reduce the amount of common boilerplate code.\n Swift is developed in the open at Swift.org, with source code, a bug tracker, forums, and regular development builds available for everyone. This broad community of developers, both inside Apple as well as hundreds of outside contributors, work together to make Swift even more amazing. There is an even broader range of blogs, podcasts, conferences and meetups where developers in the community share their experiences of how to realize Swift’s great potential.\n Swift already supports all Apple platforms and Linux, with community members actively working to port to even more platforms. With SourceKit-LSP, the community is also working to integrate Swift support into a wide-variety of developer tools. We’re excited to see more ways in which Swift makes software safer and faster, while also making programming more fun.\n While Swift powers many new apps on Apple platforms, it’s also being used for a new class of modern server applications. Swift is perfect for use in server apps that need runtime safety, compiled performance and a small memory footprint. To steer the direction of Swift for developing and deploying server applications, the community formed the Swift Server work group. The first product of this effort was SwiftNIO, a cross-platform asynchronous event-driven network application framework for high performance protocol servers and clients. It serves as the foundation for building additional server-oriented tools and technologies, including logging, metrics and database drivers which are all in active development."

class CardDetailViewController: UIViewController {
    public var cardModel: CardModel{
        didSet{
            cardContentView.model = cardModel
        }
    }
    
    public var isStatusBarHiddenWhenPresentingBySourceVC = false{
        didSet{
            if isStatusBarHiddenWhenPresentingBySourceVC != oldValue{
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    private var cardContentView = CardContentView()
    private var scrollView = UIScrollView()
    private var labelView = UILabel()
    private var dismissButton = UIButton()
    
    private  var enabledDraggingDownToDismiss = false
    
    private lazy var dismissalPanGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.maximumNumberOfTouches = 1
        return pan
    }()
    
    private lazy var dismissalScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let pan = UIScreenEdgePanGestureRecognizer()
        pan.edges = .left
        return pan
    }()
    
    private var interactiveStartingPoint: CGPoint?
    
    private let dismissalScreenEdgePanGestureDistance: CGFloat = 100
    private let dismissalPanGestureDistance: CGFloat = 100
    
    private var dismissalAnimator: UIViewPropertyAnimator?
    
    init(model: CardModel) {
        cardModel = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.addSubview(scrollView)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        scrollView.delegate = self
        scrollView.isDirectionalLockEnabled = true
        scrollView.backgroundColor = .white
        scrollView.edges(top: 0, leading: 0, bottom: 0, trailling: 0)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        scrollView.addSubview(cardContentView)
        scrollView.addSubview(labelView)
        scrollView.addSubview(dismissButton)
        
        cardContentView.edges(top: 0, leading: 0, bottom: nil, trailling: nil)
        cardContentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        cardContentView.heightAnchor.constraint(equalTo: cardContentView.widthAnchor, multiplier: 1.2).isActive = true
        cardContentView.model = cardModel
        
        var padding: CGFloat = 16
        labelView.text = text
        labelView.textColor = .black
        labelView.font = UIFont.systemFont(ofSize: 20)
        labelView.numberOfLines = 1000
        labelView.topAnchor.constraint(equalTo: cardContentView.bottomAnchor, constant: padding).isActive = true
        labelView.edges(top: nil, leading: padding, bottom: -padding, trailling: nil)
        labelView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -padding * 2).isActive = true
        
        let buttonWidth: CGFloat = 30
        dismissButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        dismissButton.setImage(UIImage(named: "cancel"), for: .normal)
        padding = 7
        dismissButton.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        dismissButton.edges(to: view, top: 35, leading: nil, bottom: nil, trailling: -25)
        dismissButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        dismissButton.heightAnchor.constraint(equalTo: dismissButton.widthAnchor).isActive = true
        dismissButton.layer.cornerRadius = buttonWidth / 2
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        
        dismissalScreenEdgePanGesture.addTarget(self, action: #selector(handleGesturePan(gesture:)))
        dismissalScreenEdgePanGesture.delegate = self
        
        dismissalPanGesture.addTarget(self, action: #selector(handleGesturePan(gesture:)))
        dismissalPanGesture.delegate = self
        dismissalPanGesture.require(toFail: dismissalScreenEdgePanGesture)
        
        view.addGestureRecognizer(dismissalPanGesture)
        view.addGestureRecognizer(dismissalScreenEdgePanGesture)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            
            let topSafeInset = view.safeAreaInsets.top
            cardContentView.topSafeInset = topSafeInset
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.scrollIndicatorInsets = .init(top: cardContentView.bounds.height, left: 0, bottom: 0, right: 0)
    }
}

extension CardDetailViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if enabledDraggingDownToDismiss || (scrollView.isTracking && scrollView.contentOffset.y < 0) {
            enabledDraggingDownToDismiss = true
            scrollView.contentOffset = .zero
        }
        
        scrollView.showsVerticalScrollIndicator = !enabledDraggingDownToDismiss
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 && scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = .zero
        }
    }
    
}

extension CardDetailViewController{
    
    private func dismissalGestureDidBegin(progress: CGFloat){
        dismissalAnimator = dismissalAnimator(progress: progress)
    }
    
    private func dismissalGestureDidChange(progress: CGFloat){
        dismissalAnimator = dismissalAnimator(progress: progress)
        
        let isDismissalSuccess = progress >= 1.0
        
        if let dismissalAnimator = dismissalAnimator{
            dismissalAnimator.fractionComplete = progress
            
            if isDismissalSuccess {
                dismissalAnimator.stopAnimation(false)
                
                dismissalAnimator.addCompletion { [unowned self] (pos) in
                    switch pos {
                    case .current, .end:
                        self.didSuccessfullyDragDownToDismiss()
                    default:
                        fatalError("Must finish dismissal at end!")
                    }
                }
                
                dismissalAnimator.finishAnimation(at: .current)
            }
        }
    }
    
    private func didSuccessfullyDragDownToDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func cancelDismissalTransition(gesture: UIGestureRecognizer) {
        if dismissalAnimator == nil {
            // Gesture's too quick that it doesn't have dismissalAnimator!
            print("Too quick there's no animator!")
            didCancelDismissalTransition()
            return
        }
        
        if let dismissalAnimator = dismissalAnimator{
            dismissalAnimator.pauseAnimation()
            dismissalAnimator.isReversed = true
            
            // Disable gesture until reverse closing animation finishes.
            gesture.isEnabled = false
            
            dismissalAnimator.addCompletion { [unowned self] (pos) in
                self.didCancelDismissalTransition()
                
                gesture.isEnabled = true
            }
            
            dismissalAnimator.startAnimation()
        }
    }
    
    private func didCancelDismissalTransition() {
        interactiveStartingPoint = nil
        dismissalAnimator = nil
        enabledDraggingDownToDismiss = false
    }
    
    private func dismissalProgress(gesture: UIPanGestureRecognizer) -> CGFloat{
        let isScreenEdgePan = gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self)
        
        guard isScreenEdgePan || enabledDraggingDownToDismiss else {
            return 0
        }
        
        var progress: CGFloat
        
        if isScreenEdgePan{
            progress = gesture.translation(in: gesture.view).x / dismissalScreenEdgePanGestureDistance
        }else{
            
            if let startingPoint = interactiveStartingPoint{
                let currentPoint = gesture.location(in: gesture.view)
                progress = (currentPoint.y - startingPoint.y) / dismissalPanGestureDistance
                
            }else{
                progress = 0
            }
            
        }
        
        return progress
    }
    
    @objc private func dismissButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    private func dismissalAnimator(progress: CGFloat) -> UIViewPropertyAnimator{
        if let animator = dismissalAnimator {
            return animator
        } else {
            
            let shrinkScaleTarget: CGFloat = 0.86
            let cornerRadius: CGFloat = 16
            
            let animator = UIViewPropertyAnimator(duration: 0.1, curve: .linear, animations: {[weak self] in
                self?.view.transform = .init(scaleX: shrinkScaleTarget, y: shrinkScaleTarget)
                self?.view.layer.cornerRadius = cornerRadius
                
                self?.dismissButton.alpha = 0
            })
            
            animator.isReversed = false
            animator.pauseAnimation()
            animator.fractionComplete = progress
            
            return animator
        }
    }
    
    private func canHandleDismissalGesture(gesture: UIPanGestureRecognizer) -> Bool{
        let isScreenEdgePan = gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self)
        
        return (isScreenEdgePan || enabledDraggingDownToDismiss) && gesture.view != nil && scrollView.contentOffset == .zero
    }
    
    private func handleDismissalGesture(gesture: UIPanGestureRecognizer){
        // Update startingPoint
        if interactiveStartingPoint == nil {
            interactiveStartingPoint = gesture.location(in: gesture.view)
        }
        
        let progress = dismissalProgress(gesture: gesture)
        
        switch gesture.state {
        case .began:
            dismissalGestureDidBegin(progress: progress)
            
        case .changed:
            dismissalGestureDidChange(progress: progress)
            
        case .ended, .cancelled:
            cancelDismissalTransition(gesture: gesture)
            
        default:
            fatalError("Impossible gesture state? \(gesture.state.rawValue)")
        }
    }
    
    @objc func handleGesturePan(gesture: UIPanGestureRecognizer) {
        if canHandleDismissalGesture(gesture: gesture){
            handleDismissalGesture(gesture: gesture)
        }
    }
}

extension CardDetailViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension CardDetailViewController: DestinationTransitionDelegate{
    
    func presentingDestTransitionWillBegin(){
        dismissButton.alpha = 0
        
        cardContentView.layer.cornerRadius = 16
        cardContentView.topSafeInset = 0
    }
    
    func presentingDestAnimation(containnerView containner: UIView) {
        dismissButton.alpha = 1
        
        cardContentView.layer.cornerRadius = 0
        if #available(iOS 11.0, *) {
            cardContentView.topSafeInset = view.safeAreaInsets.top
        }
        
        isStatusBarHiddenWhenPresentingBySourceVC = true
    }
    
    func presentingDestTransitionDidEnd(){
        
    }
    
    func dismissalDestTransitionWillBegin(){
   
    }
    
    func dismissingDestAnimation(containnerView containner: UIView) {
        dismissButton.alpha = 0
        
        cardContentView.layer.cornerRadius = 16
        cardContentView.topSafeInset = 0
        
        scrollView.contentOffset = .zero
        
        view.transform = .identity
    }
    
    func dismissalDestTransitionDidEnd(_ completed: Bool) {
        
    }
}

extension CardDetailViewController{
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isStatusBarHiddenWhenPresentingBySourceVC
    }
}
