//
//  TagListView.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 02/01/2024.
//

import UIKit

@objc public protocol TagListViewDelegate {
    @objc optional func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    @objc optional func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
}

@IBDesignable
open class TagListView: UIView {

    @IBInspectable open dynamic var textColor: UIColor = .white {
        didSet {
            tagViews.forEach {
                $0.textColor = textColor
            }
        }
    }

    @IBInspectable open dynamic var selectedTextColor: UIColor = .white {
        didSet {
            tagViews.forEach {
                $0.selectedTextColor = selectedTextColor
            }
        }
    }

    @IBInspectable open dynamic var tagLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            tagViews.forEach {
                $0.titleLineBreakMode = tagLineBreakMode
            }
        }
    }

    @IBInspectable open dynamic var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            tagViews.forEach {
                $0.tagBackgroundColor = tagBackgroundColor
            }
        }
    }

    @IBInspectable open dynamic var tagHighlightedBackgroundColor: UIColor? {
        didSet {
            tagViews.forEach {
                $0.highlightedBackgroundColor = tagHighlightedBackgroundColor
            }
        }
    }

    @IBInspectable open dynamic var tagSelectedBackgroundColor: UIColor? {
        didSet {
            tagViews.forEach {
                $0.selectedBackgroundColor = tagSelectedBackgroundColor
            }
        }
    }

    @IBInspectable open dynamic var cornerRadius: CGFloat = 0 {
        didSet {
            tagViews.forEach {
                $0.cornerRadius = cornerRadius
            }
        }
    }
    @IBInspectable open dynamic var borderWidth: CGFloat = 0 {
        didSet {
            tagViews.forEach {
                $0.borderWidth = borderWidth
            }
        }
    }

    @IBInspectable open dynamic var borderColor: UIColor? {
        didSet {
            tagViews.forEach {
                $0.borderColor = borderColor
            }
        }
    }

    @IBInspectable open dynamic var selectedBorderColor: UIColor? {
        didSet {
            tagViews.forEach {
                $0.selectedBorderColor = selectedBorderColor
            }
        }
    }

    @IBInspectable open dynamic var paddingY: CGFloat = 2 {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.paddingY = paddingY
            }
        }
    }
    @IBInspectable open dynamic var paddingX: CGFloat = 5 {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.paddingX = paddingX
            }
        }
    }
    @IBInspectable open dynamic var marginY: CGFloat = 2 {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var marginX: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }

    @IBInspectable open dynamic var minWidth: CGFloat = 0 {
        didSet {
            rearrangeViews()
        }
    }

    @objc public enum Alignment: Int {
        case left
        case center
        case right
        case leading
        case trailing
    }
    @IBInspectable open var alignment: Alignment = .leading {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowColor: UIColor = .white {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowRadius: CGFloat = 0 {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowOffset: CGSize = .zero {
        didSet {
            rearrangeViews()
        }
    }
    @IBInspectable open dynamic var shadowOpacity: Float = 0 {
        didSet {
            rearrangeViews()
        }
    }

    @IBInspectable open dynamic var enableRemoveButton: Bool = false {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.enableRemoveButton = enableRemoveButton
            }
        }
    }

    @IBInspectable open dynamic var removeButtonIconSize: CGFloat = 12 {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.removeButtonIconSize = removeButtonIconSize
            }
        }
    }
    @IBInspectable open dynamic var removeIconLineWidth: CGFloat = 1 {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.removeIconLineWidth = removeIconLineWidth
            }
        }
    }

    @IBInspectable open dynamic var removeIconLineColor: UIColor = UIColor.white.withAlphaComponent(0.54) {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.removeIconLineColor = removeIconLineColor
            }
        }
    }

    @objc open dynamic var textFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.textFont = textFont
            }
        }
    }

    @IBOutlet open weak var delegate: TagListViewDelegate?

    open private(set) var tagViews: [TagView] = []
    private(set) var tagBackgroundViews: [UIView] = []
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    var minFrameWidth: CGFloat = 0

    // MARK: - Interface Builder

    open override func prepareForInterfaceBuilder() {
    }

    // MARK: - Layout

    open override func layoutSubviews() {
        defer { rearrangeViews() }
        super.layoutSubviews()
    }

    private func rearrangeViews() {
        let views = tagViews as [UIView] + tagBackgroundViews + rowViews
        views.forEach {
            $0.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)

        let isRtl: Bool = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft

        var alignment = self.alignment

        if alignment == .leading {
            alignment = isRtl ? .right : .left
        }
        else if alignment == .trailing {
            alignment = isRtl ? .left : .right
        }

        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        let frameWidth = max(frame.width, minFrameWidth)

        let directionTransform = isRtl
            ? CGAffineTransform(scaleX: -1.0, y: 1.0)
            : CGAffineTransform.identity

        for (index, tagView) in tagViews.enumerated() {
            tagView.frame.size = tagView.intrinsicContentSize
            tagViewHeight = tagView.frame.height

            if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > frameWidth {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.transform = directionTransform
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + marginY)

                rowViews.append(currentRowView)
                addSubview(currentRowView)

                tagView.frame.size.width = min(tagView.frame.size.width, frameWidth)
            }

            let tagBackgroundView = tagBackgroundViews[index]
            tagBackgroundView.transform = directionTransform
            tagBackgroundView.frame.origin = CGPoint(
                x: currentRowWidth,
                y: 0)
            tagBackgroundView.frame.size = tagView.bounds.size
            tagView.frame.size.width = max(minWidth, tagView.frame.size.width)
            tagBackgroundView.layer.shadowColor = shadowColor.cgColor
            tagBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: tagBackgroundView.bounds, cornerRadius: cornerRadius).cgPath
            tagBackgroundView.layer.shadowOffset = shadowOffset
            tagBackgroundView.layer.shadowOpacity = shadowOpacity
            tagBackgroundView.layer.shadowRadius = shadowRadius
            tagBackgroundView.addSubview(tagView)
            currentRowView.addSubview(tagBackgroundView)

            currentRowTagCount += 1
            currentRowWidth += tagView.frame.width + marginX

            switch alignment {
            case .leading: fallthrough // switch must be exahutive
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frameWidth - (currentRowWidth - marginX)) / 2
            case .trailing: fallthrough // switch must be exahutive
            case .right:
                currentRowView.frame.origin.x = frameWidth - (currentRowWidth - marginX)
            }
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
        }
        rows = currentRow

        invalidateIntrinsicContentSize()
    }

    // MARK: - Manage tags

    override open var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + marginY)
        if rows > 0 {
            height -= marginY
        }
        return CGSize(width: frame.width, height: height)
    }

//    private func createNewTagView(_ title: String) -> TagView {
//        let tagView = TagView(title: title)
//
//        tagView.textColor = textColor
//        tagView.selectedTextColor = selectedTextColor
//        tagView.tagBackgroundColor = tagBackgroundColor
//        tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
//        tagView.selectedBackgroundColor = tagSelectedBackgroundColor
//        tagView.titleLineBreakMode = tagLineBreakMode
//        tagView.cornerRadius = cornerRadius
//        tagView.borderWidth = borderWidth
//        tagView.borderColor = borderColor
//        tagView.selectedBorderColor = selectedBorderColor
//        tagView.paddingX = paddingX
//        tagView.paddingY = paddingY
//        tagView.textFont = textFont
//        tagView.removeIconLineWidth = removeIconLineWidth
//        tagView.removeButtonIconSize = removeButtonIconSize
//        tagView.enableRemoveButton = enableRemoveButton
//        tagView.removeIconLineColor = removeIconLineColor
//        tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)
//        tagView.removeButton.addTarget(self, action: #selector(removeButtonPressed(_:)), for: .touchUpInside)
//
//        // On long press, deselect all tags except this one
//        tagView.onLongPress = { [unowned self] this in
//            self.tagViews.forEach {
//                $0.isSelected = $0 == this
//            }
//        }
//
//        return tagView
//    }

    private func createNewTagView(_ skill: Skills) -> TagView {
        let tagView = TagView(title: skill.title)

        tagView.isSelected = skill.isSelected
        tagView.textColor = textColor
        tagView.selectedTextColor = selectedTextColor
        tagView.tagBackgroundColor = tagBackgroundColor
        tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
        tagView.selectedBackgroundColor = tagSelectedBackgroundColor
        tagView.titleLineBreakMode = tagLineBreakMode
        tagView.cornerRadius = cornerRadius
        tagView.borderWidth = borderWidth
        tagView.borderColor = borderColor
        tagView.selectedBorderColor = selectedBorderColor
        tagView.paddingX = paddingX
        tagView.paddingY = paddingY
        tagView.textFont = textFont
        tagView.removeIconLineWidth = removeIconLineWidth
        tagView.removeButtonIconSize = removeButtonIconSize
        tagView.enableRemoveButton = enableRemoveButton
        tagView.removeIconLineColor = removeIconLineColor
        tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)
        tagView.removeButton.addTarget(self, action: #selector(removeButtonPressed(_:)), for: .touchUpInside)

        // On long press, deselect all tags except this one
        tagView.onLongPress = { [unowned self] this in
            self.tagViews.forEach {
                $0.isSelected = $0 == this
            }
        }

        return tagView
    }


//    @discardableResult
//    open func addTags(_ titles: [String]) -> [TagView] {
//        return addTagViews(titles.map(createNewTagView))
//    }

    //@discardableResult
    func addTags(_ skills: [Skills]) {
        //let titles = skills.map { $0.title }
        addTagViews(skills.map(createNewTagView))
    }

    @discardableResult
    open func addTagViews(_ tagViewList: [TagView]) -> [TagView] {
        defer { rearrangeViews() }
        tagViewList.enumerated().forEach { (index, tagView) in
            tagView.tag = index
            tagViews.append(tagView)
            tagBackgroundViews.append(UIView(frame: tagView.bounds))
        }
        return tagViews
    }

    open func removeAllTags() {
        defer {
            tagViews = []
            tagBackgroundViews = []
            rearrangeViews()
        }

        let views: [UIView] = tagViews + tagBackgroundViews
        views.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Events

    @objc func tagPressed(_ sender: TagView!) {
        sender.isSelected.toggle()
        sender.onTap?(sender)
        delegate?.tagPressed?(sender.currentTitle ?? "", tagView: sender, sender: self)
    }

    @objc func removeButtonPressed(_ closeButton: CloseButton!) {
        if let tagView = closeButton.tagView {
            delegate?.tagRemoveButtonPressed?(tagView.currentTitle ?? "", tagView: tagView, sender: self)
        }
    }
}
