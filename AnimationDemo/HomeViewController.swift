//
//  ViewController.swift
//  AnimationDemo
//
//  Created by Truong Nguyen on 3/24/20.
//  Copyright © 2020 Truong Nguyen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    private weak var selectedCell: UICollectionViewCell?
    
    private var collectionView: UICollectionView!
    
    private var transition: CardTransition?
    
    private var button: UIButton!
     
    private var tabbarFrame: CGRect?
    
    private var cardModels: [CardModel] = [
        CardModel(primary: "GAME OF THE DAY",
                  secondary: "Minecraft makes a splash",
                  description: "The ocean is a big place. Tap to read how Minecraft's just got even bigger.",
                  image: UIImage(named: "img1")!),
        CardModel(primary: "You won't believe this guy",
                  secondary: "Something we want",
                  description: "They have something we want which is not something we need.",
                  image: UIImage(named: "img2")!),
        CardModel(primary: "You are beautiful",
                  secondary: "Kiss me if you want",
                  description: "Vertical Game Background (With images) | Game background ...",
                  image: UIImage(named: "img5")!),
        CardModel(primary: "LET'S PLAY",
                  secondary: "Cats, cats, cats!",
                  description: "Play these games right meo. We gooooo...",
                  image: UIImage(named: "img3")!),
        CardModel(primary: "What's your name",
                  secondary: "Kill Me. GO",
                  description: "Toxic Ocean Game Background with Obstacles by bevouliin on Dribbble",
                  image: UIImage(named: "img4")!),
    ]
    
    public var isTabbarHiddenWhenDismissingDestVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let viewFlowLayout = UICollectionViewFlowLayout()
        let cardHorizontalOffset: CGFloat = 25
        let cardHeightByWidthRatio: CGFloat = 1.2
        let width = UIScreen.main.bounds.width - 2 * cardHorizontalOffset
        let height: CGFloat = width * cardHeightByWidthRatio
        viewFlowLayout.itemSize = CGSize(width: width, height: height)
        viewFlowLayout.minimumLineSpacing = 20
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: viewFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        collectionView.delaysContentTouches = false
        
        view.addSubview(collectionView)
        
        let buttonHeight: CGFloat = 30
        button = UIButton()
        button.frame = CGRect(x: view.frame.maxX - buttonHeight * 2, y: view.frame.maxY - 200, width: buttonHeight, height: buttonHeight)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.setImage(UIImage(named: "double_down_arrow"), for: .normal)
        button.isHidden = true
        view.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if tabbarFrame == nil{
            tabbarFrame = tabBarController?.tabBar.frame
        }
    }
}

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CardCell else {
            fatalError("You don't register cell")
        }
        
        cell.model = cardModels[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardModels.count
    }
}

extension HomeViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        selectedCell = cell
        
        cell.freezeAnimations()
        
        // Get current frame on collectionView
        let currentCellFrame = cell.layer.presentation()!.frame
        
        // Convert current frame to screen's coordinates
        // current frame on Screen
        let cardPresentationFrameOnScreen = cell.superview!.convert(currentCellFrame, to: nil)
        
        // Get card frame without transform in screen's coordinates  (for the dismissing back later to original location)
        let cardFrameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        }()
        
        let vc = CardDetailViewController(model: cardModels[indexPath.row])
        vc.isStatusBarHiddenWhenPresentingBySourceVC = true
        
        let params = CardTransition.Params(verticalExpandingStyle: .fromTop,
                                           originalCardFrame: cardPresentationFrameOnScreen,
                                           originalCardFrameWithoutTransform: cardFrameWithoutTransform,
                                           sourceTransition: self,
                                           destTransition: vc)
        transition = CardTransition(params: params)
        vc.transitioningDelegate = transition
        vc.modalPresentationCapturesStatusBarAppearance = true
        vc.modalPresentationStyle = .custom
        
        present(vc, animated: true, completion: { [unowned cell] in
            // Unfreeze
            cell.unfreezeAnimations()
        })
    }
}

extension HomeViewController: SourceTransitionDelegate{
    func sourceTransitionPresentWillBegin() {
        selectedCell?.isHidden = true
        
        (selectedCell as? CardCell)?.resetTransform()
    }
    
    func sourceTransitionPresentingAnimation(containnerView containner: UIView) {
        if isTabbarHiddenWhenDismissingDestVC{
            tabBarController?.tabBar.frame.origin.y += tabBarController?.tabBar.frame.height ?? 0
        }
    }
    
    func sourceTransitionDismissingAnimation(containnerView containner: UIView) {
        if isTabbarHiddenWhenDismissingDestVC, let tabbarFrame = tabbarFrame{
            tabBarController?.tabBar.frame = tabbarFrame
        }
    }
    
    func sourceTransitionDismissDidEnd(_ completed: Bool) {
        if completed{
            selectedCell?.isHidden = false
        }
    }
    
    func safeInsetWhenSourceTransitionDismissing() -> UIEdgeInsets {
        var safeInset: UIEdgeInsets
        if #available(iOS 11.0, *) {
            safeInset = view.safeAreaInsets
            safeInset.top = 0
        } else {
            safeInset = .zero
        }
        
        return safeInset
    }
}


