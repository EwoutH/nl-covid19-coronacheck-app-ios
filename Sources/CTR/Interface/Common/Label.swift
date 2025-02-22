/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

/// Styled UILabel subclass providing convenience initialization for each text style support in the [Theme](x-source-tag://Theme)
class Label: UILabel {
    
	init(_ text: String?, font: UIFont = Theme.fonts.body, textColor: UIColor = Theme.colors.dark) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = font
        self.textColor = textColor
		self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(largeTitle: String?, textColor: UIColor = .darkText) {
        self.init(largeTitle, font: Theme.fonts.largeTitle, textColor: textColor)
    }
    
	convenience init(title1: String?, textColor: UIColor = .darkText, montserrat: Bool = false) {
		if montserrat {
			self.init(title1, font: Theme.fonts.title1Montserrat, textColor: textColor)
			adjustsFontForContentSizeCategory = true
		} else {
			self.init(title1, font: Theme.fonts.title1, textColor: textColor)
		}
	}

    convenience init(title2: String?, textColor: UIColor = .darkText) {
        self.init(title2, font: Theme.fonts.title2, textColor: textColor)
    }

	convenience init(title3: String?, textColor: UIColor = .darkText, montserrat: Bool = false) {
		if montserrat {
			self.init(title3, font: Theme.fonts.title3Montserrat, textColor: textColor)
			adjustsFontForContentSizeCategory = true
		} else {
			self.init(title3, font: Theme.fonts.title3, textColor: textColor)
		}
	}

	convenience init(title3Medium: String?, textColor: UIColor = .darkText) {
		self.init(title3Medium, font: Theme.fonts.title3Medium, textColor: textColor)
	}
    
    convenience init(headline: String?, textColor: UIColor = .darkText) {
        self.init(headline, font: Theme.fonts.headline, textColor: textColor)
    }

	convenience init(headlineBold: String?, textColor: UIColor = .darkText) {
		self.init(headlineBold, font: Theme.fonts.headlineBold, textColor: textColor)
	}
    
    convenience init(body: String?, textColor: UIColor = .darkText) {
        self.init(body, font: Theme.fonts.body, textColor: textColor)
    }
    
    convenience init(bodyBold: String?, textColor: UIColor = .darkText) {
        self.init(bodyBold, font: Theme.fonts.bodyBold, textColor: textColor)
    }

	convenience init(bodySemiBold: String?, textColor: UIColor = .darkText) {
		self.init(bodySemiBold, font: Theme.fonts.bodySemiBold, textColor: textColor)
	}

	convenience init(bodyMedium: String?, textColor: UIColor = .darkText) {
		self.init(bodyMedium, font: Theme.fonts.bodyMedium, textColor: textColor)
	}

    convenience init(callout: String?, textColor: UIColor = .darkText) {
        self.init(callout, font: Theme.fonts.callout, textColor: textColor)
    }

	convenience init(calloutSemiBold: String?, textColor: UIColor = .darkText) {
		self.init(calloutSemiBold, font: Theme.fonts.calloutSemiBold, textColor: textColor)
	}
    
    convenience init(subhead: String?, textColor: UIColor = .darkText) {
        self.init(subhead, font: Theme.fonts.subhead, textColor: textColor)
    }
    
    convenience init(subheadBold: String?, textColor: UIColor = .darkText) {
        self.init(subheadBold, font: Theme.fonts.subheadBold, textColor: textColor)
    }

	convenience init(subheadMedium: String?, textColor: UIColor = .darkText) {
		self.init(subheadMedium, font: Theme.fonts.subheadMedium, textColor: textColor)
	}
    
    convenience init(footnote: String?, textColor: UIColor = .darkText) {
        self.init(footnote, font: Theme.fonts.footnote, textColor: textColor)
    }
    
    convenience init(caption1: String?, textColor: UIColor = .darkText) {
        self.init(caption1, font: Theme.fonts.caption1, textColor: textColor)
    }

	convenience init(caption1SemiBold: String?, textColor: UIColor = .darkText) {
		self.init(caption1SemiBold, font: Theme.fonts.caption1SemiBold, textColor: textColor)
	}
    
    @discardableResult
    func multiline() -> Self {
        numberOfLines = 0
        return self
    }
    
    @discardableResult
    func hideIfEmpty() -> Self {
        isHidden = text?.isEmpty == true
        return self
    }

	@discardableResult
	func asHTML() -> Self {
		attributedText = .makeFromHtml(text: text, font: font, textColor: textColor, boldTextColor: Theme.colors.dark)
		return self
	}
}
