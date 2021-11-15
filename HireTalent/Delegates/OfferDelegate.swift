//
//  OfferDelegate.swift
//  HireTalent
//
//  Created by Andres Ruiz Navejas on 09/05/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import Foundation

protocol OfferDelegate {
    func updateOfferView(controller: AnyObject, newOffer: JobOffer)
}
