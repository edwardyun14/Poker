//
//  Deck.swift
//  Poker
//
//  Created by Edward Yun on 11/4/15.
//  Copyright © 2015 Edward Yun. All rights reserved.
//

import Foundation

var Suits = ["Clubs", "Hearts", "Spades", "Diamonds"]
var Ranks = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
var deckSize:UInt32 = 52

var orderedRanks = ["Ace": 14, "Two": 2, "Three": 3, "Four" : 4, "Five" : 5, "Six" : 6, "Seven" : 7, "Eight" : 8, "Nine" : 9, "Ten" : 10, "Jack" : 11, "Queen" : 12, "King": 13]

class Card: CustomStringConvertible {
    
    var suit: String
    var rank: String
    
    init(suit: String, rank: String) {
        self.suit = suit
        self.rank = rank;
    }
    
    var description: String {
        return "\(rank) of \(suit)"
    }
    
}


class Deck: CustomStringConvertible {
    
    var deck = [Card]()
    
    init() {
        create()
    }
    
    func create() {
        for suit in Suits {
            for rank in Ranks {
                let newCard = Card(suit: suit, rank: rank)
                self.deck.append(newCard)
            }
        }
        shuffle()
    }
    
    func shuffle() {
        var seed = false
        var random: UInt32 = 0
        let intDeck:Int = Int(deckSize)
        for var i = 0; i < intDeck; i++ {
            if (!seed) {
                seed = true
                random = arc4random_uniform(deckSize)
            }
            let nElements = intDeck - i
            let n = (Int(random) % nElements) + i
            //print("i is \(i); n is \(n)")
            
            // prevent swapping with self
            if i != n {
                swap(&deck[i], &deck[n])
            }
            seed = false
        }
    }
    
    func deal() -> Card {
        let card = deck.removeAtIndex(0)
        return card
    }
    
    func dealHands(players: Int) -> [HoleCards]{
        var hands = [HoleCards]()
        for _ in 0...players - 1 {
            hands.append(HoleCards(first: deal(), second: deal()))
        }
        return hands
    }
    
    func flop() -> [Card] {
        var flop = [Card]()
        for _ in 0...2 {
            deal()
            flop.append(deal())
        }
        
        return flop
    }
    
    func turn() -> Card {
        deal()
        return deal()
    }
    
    func river() -> Card {
        deal()
        return deal()
    }
    
    func shuffleCards(number: Int) {
        deck = [Card]()
        create()
        for _ in 0...number {
            shuffle()
        }
    }
    
    var description: String {
        var des = ""
        for card in deck {
            des += "\(card.rank) of \(card.suit), "
        }
        return des
    }
}

class HoleCards: CustomStringConvertible {
    var first: Card
    var second: Card
    var bestHand = [Card]()
    
    init (first: Card, second: Card) {
        self.first = first
        self.second = second
    }
    
    func calculateHandRank(communityCards: [Card]) -> Int {
        var allCards = [Card]()
        allCards.append(first)
        allCards.append(second)
        for card in communityCards {
            allCards.append(card)
        }
        allCards = sort(allCards)
        
        var tempCards = [Card(suit: "Hearts", rank: "Ace"), Card(suit: "Spades", rank: "Ace"), Card(suit: "Hearts",rank: "Ace"), Card(suit: "Clubs", rank: "Queen"), Card(suit: "Diamonds",rank: "King"), Card(suit: "Spades", rank: "King")]
                
        if isRoyalFlush(allCards) {
            return 10
        } else if isStraightFlush(allCards) {
            return 9
        } else if isQuads(allCards) {
            return 8
        } else if isFullHouse(allCards) {
            return 7
        } else if isFlush(allCards) {
            return 6
        } else if isStraight(allCards) {
            return 5
        } else if isTrips(allCards) {
            return 4
        } else if isTwoPair(allCards) {
            return 3
        } else if isPair(allCards) {
            return 2
        } else if isHighCard(allCards) {
            return 1
        } else {
            return 0
        }
    }
    
    func isRoyalFlush(cards: [Card]) -> Bool {
        //TODO: make it royal flush
        
        if isStraight(cards) && isFlush(cards) && orderedRanks[cards[0].rank] == 14 {
            return true
        }
        return false
    }
    
    func isStraightFlush(cards: [Card]) -> Bool {
        //TODO: straight flush algorithm
        if isStraight(cards) && isFlush(cards) {
            return true
        }
        return false
    }
    
    // broken
    func isQuads(cards: [Card]) -> Bool {
        let ranks = histogram(cards)
        for (rank, count) in ranks {
            if count > 3 {
                print("Quads! \(count) \(rank)!")
                return true
            }
        }
        return false
    }
    
    func isFullHouse(cards: [Card]) -> Bool {
        let ranks = histogram(cards)
        for (rank, count) in ranks {
            if count > 2 {
                for (secondRank, secondCount) in ranks {
                    if secondCount > 1 && secondRank != rank {
                        print("Full House! \(rank) over \(secondRank)")
                        return true
                    }
                }
            }
        }
        print("ranks is \(ranks)")
        return false
    }
    
    func isFlush(cards: [Card]) -> Bool {
        
        var suits = [String: Int]()
        
        for card in cards {
            for (suit, count) in suits {
                if card.suit == suit {
                    suits[suit] = count + 1
                } else {
                    suits[card.suit] = 1
                }
            }
        }
        
        for (suit, count) in suits {
            if count > 4 {
                print("Flush! \(count) \(suit)s")
                return true
            }
        }
        
        return false
    }
    
    func isStraight(var cards: [Card]) -> Bool {
        // TODO: support for wheel (A 2 3 4 5)
        var count = 0
        var prev = cards[0]
        for card in cards {
            
            if orderedRanks[card.rank]! == orderedRanks[prev.rank]! {
                continue
            }
            if orderedRanks[card.rank]! == orderedRanks[prev.rank]! - 1 {
                count++
                print("Count increased to \(count). Current card is \(card)")
            } else {
                count = 0
            }
            if count == 4 {
                print("Suit! \(cards)")
                return true
            }
            prev = card
        }
        return false
    }
    
    // Working!
    func isTrips(cards: [Card]) -> Bool {
        let ranks = histogram(cards)
        for (rank, count) in ranks {
            if count > 2 {
                print("Trips! \(count) \(rank)s!")
                return true
            }
        }
        return false
    }
   
    func isTwoPair(cards: [Card]) -> Bool {
        let ranks = histogram(cards)
        for (rank, count) in ranks {
            if count > 1 {
                for (secondRank, secondCount) in ranks {
                    if secondCount > 1 && secondRank != rank{
                        print("Two pair! \(rank)s and \(secondRank)s")
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func isPair(cards: [Card]) -> Bool {
        let ranks = histogram(cards)
        for (rank, count) in ranks {
            if count > 1 {
                print("Pair! \(rank)s")
                return true
            }
        }
        return false
    }
    
    func isHighCard(cards: [Card]) -> Bool {
        let ranks = histogram(cards)
        for (rank, count) in ranks {
            if count > 1 {
                return false
            }
        }
        print("High card!")
        return true
    }
    
    func histogram(cards: [Card]) -> [String: Int] {
        var cardCount = [String: Int]()
        for card in cards {
            if cardCount[card.rank] == nil {
                cardCount[card.rank] = 1
            } else {
                cardCount[card.rank]!++
            }
        }
        return cardCount
    }
    
    func sort(var cards: [Card]) -> [Card] {
        cards.append(first)
        cards.append(second)
        return quickSort(cards, lowerIndex: 0, higherIndex: cards.count - 1)

    }
    
    private func quickSort(var cards: [Card], lowerIndex: Int, higherIndex: Int) -> [Card]{
        var i = lowerIndex
        var j = higherIndex
        let pivot = cards[lowerIndex + (higherIndex - lowerIndex)/2]
        while i <= j {
            while orderedRanks[cards[i].rank]! > orderedRanks[pivot.rank]! {
                i++
            }
            while orderedRanks[cards[j].rank]! < orderedRanks[pivot.rank]! {
                j--
            }
            if i <= j {
                cards = exchangeNumbers(cards, i: i, j: j)
                i++
                j--
            }
        }
        if lowerIndex < j {
            cards = quickSort(cards, lowerIndex: lowerIndex, higherIndex: j)
        }
        if i < higherIndex {
            cards = quickSort(cards, lowerIndex: i, higherIndex: higherIndex)
        }
        return cards
        
    }
    
    private func exchangeNumbers(var cards: [Card], i: Int, j: Int) -> [Card] {
        let temp = cards[i]
        cards[i] = cards[j]
        cards[j] = temp
        return cards
    }
    
    var description: String {
        return "\(first.rank) of \(first.suit) and \(second.rank) of \(second.suit)"
    }
    
}