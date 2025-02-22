/*
 * Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit

class ImageView: UIImageView {
    
    init(imageName: String, highlightedImageName: String? = nil) {
        super.init(image: UIImage(named: imageName))
        
        if let highlightedImageName = highlightedImageName {
            highlightedImage = UIImage(named: highlightedImageName)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    func asIcon() -> Self {
        contentMode = .center
        setContentHuggingPriority(.required, for: .horizontal)
        tintColor = Theme.colors.primary
        return self
    }
    
}
