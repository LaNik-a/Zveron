//
//  LotCell.swift
//  iosapp
//
//  Created by alexander on 01.05.2022.
//

import Foundation
import UIKit
import RxSwift
import RemoteDataService

class LotCell: UICollectionViewCell {
    public static let reusableIdentifier = "lotCell"

    let viewModel = ViewModelFactory.get(LotCellViewModel.self)

    var disposeBag: DisposeBag {
        return viewModel.disposeBag
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
        bindViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setPresentationStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private  let imageLot: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private  let lotLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1058823529, alpha: 1)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private  let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1058823529, alpha: 1)
        return label
    }()

    private   let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private var tablePresentationConstraints: [NSLayoutConstraint] = []
    private var gridPresentationConstraints: [NSLayoutConstraint] = []

    private func initialSetUp() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = true

        addSubview(imageLot)
        addSubview(lotLabel)
        addSubview(favoriteButton)
        addSubview(priceLabel)
        addSubview(dateLabel)
        imageLot.translatesAutoresizingMaskIntoConstraints = false
        lotLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }

   private func setPresentationStyle() {
       let isTablePresentation = frame.width > frame.height
       if tablePresentationConstraints.isEmpty && isTablePresentation { initTablePresentationConstraints() }
       if gridPresentationConstraints.isEmpty && !isTablePresentation { initGridPresentationConstraints() }

       tablePresentationConstraints.forEach { $0.isActive = isTablePresentation }
       gridPresentationConstraints.forEach { $0.isActive = !isTablePresentation }

       let lotLabelFontSize: CGFloat = isTablePresentation ? 15 : 13
       let priceLabelFontSize: CGFloat = isTablePresentation ? 17 : 15
       let dateLabelFontSize: CGFloat = isTablePresentation ? 11 : 9

       lotLabel.font = .systemFont(ofSize: lotLabelFontSize, weight: .regular)
       priceLabel.font = .systemFont(ofSize: priceLabelFontSize, weight: .medium)
       dateLabel.font = .systemFont(ofSize: dateLabelFontSize, weight: .light)

   }

    private func initTablePresentationConstraints() {
        tablePresentationConstraints = [
            imageLot.topAnchor.constraint(equalTo: topAnchor),
            imageLot.leftAnchor.constraint(equalTo: leftAnchor),
            imageLot.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageLot.widthAnchor.constraint(equalToConstant: frame.width * 0.5),

            lotLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            lotLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8),
            lotLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),

            favoriteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: frame.width / 10),

            priceLabel.topAnchor.constraint(equalTo: lotLabel.bottomAnchor, constant: 4),
            priceLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8),

            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            dateLabel.leftAnchor.constraint(equalTo: imageLot.rightAnchor, constant: 8)
        ]
    }

    private func initGridPresentationConstraints() {
        gridPresentationConstraints = [
            imageLot.topAnchor.constraint(equalTo: topAnchor),
            imageLot.leftAnchor.constraint(equalTo: leftAnchor),
            imageLot.rightAnchor.constraint(equalTo: rightAnchor),
            imageLot.heightAnchor.constraint(equalToConstant: frame.height / 2),

            lotLabel.topAnchor.constraint(equalTo: imageLot.bottomAnchor, constant: 8),
            lotLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            lotLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor, constant: -16),

            favoriteButton.topAnchor.constraint(equalTo: imageLot.bottomAnchor, constant: 8),
            favoriteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: frame.width / 6),

            priceLabel.topAnchor.constraint(equalTo: lotLabel.bottomAnchor, constant: 4),
            priceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),

            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        ]
    }

    private func bindViews() {
        viewModel.title.bind(to: lotLabel.rx.text).disposed(by: disposeBag)
        viewModel.price.bind(to: priceLabel.rx.text).disposed(by: disposeBag)
        viewModel.date.bind(to: dateLabel.rx.text).disposed(by: disposeBag)
        viewModel.favoriteImage.bind(to: favoriteButton.rx.image(for: .normal)).disposed(by: disposeBag)
        viewModel.pictureUrl.subscribe(onNext: { url in
            self.imageLot.kf.setImage(with: url)
        }).disposed(by: disposeBag)

        favoriteButton.rx.tap.subscribe { _ in
            guard self.viewModel.data.value?.status == nil else { return }
            self.viewModel.updateFavoriteState()
        }.disposed(by: disposeBag)

        viewModel.status.bind(onNext: { status in
            self.alpha = status == "ACTIVE" ? 1.0 : 0.5
        }).disposed(by: disposeBag)
    }
}
