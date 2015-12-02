//
//  HostHandViewController.swift
//  Poker
//
//  Created by Edward Yun on 12/1/15.
//  Copyright © 2015 Edward Yun. All rights reserved.
//

import UIKit

class HostHandViewController: UIViewController {
    
    var numberOfPlayers: Int!
    @IBOutlet weak var leftCardView: CardView!
    @IBOutlet weak var rightCardView: CardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeDeck()
        

    }
    
    func initializeDeck() {
        let newDeck = Deck()
        newDeck.shuffleCards(3)
        let hands = newDeck.dealHands(numberOfPlayers)
        
        createHoleCards(hands[0].first, secondCard: hands[0].second)
        
        var communityCards = newDeck.flop()
        communityCards.append(newDeck.turn())
        communityCards.append(newDeck.river())
        print(communityCards)
        
        
    }
    
    func createHoleCards(firstCard: Card, secondCard: Card) {
        
        print(firstCard.rank)
        print(firstCard.suit)
        
        leftCardView.loadCard(firstCard.rank, suit: firstCard.suit)
        rightCardView.loadCard(secondCard.rank, suit: secondCard.suit)
        
    }

}
