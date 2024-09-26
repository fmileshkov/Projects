//
//  ReusableListView.swift
//  MovieCave
//
//  Created by Admin on 11.10.23.
//

import UIKit
import Combine

struct ReusableListViewConstants {
    static let stackViewTrailingAnchorConstraint: CGFloat = -8
    static let stackViewLeadingAnchorConstraint: CGFloat = 8
    static let filterButtonTitleLabelFontSize: CGFloat = 16
    static let filterButtonLayerCornerRadius: CGFloat = 5
    static let filterButtonHeightAnchorConstraint: CGFloat = 25
    static let reusableListViewStackViewSpacing: CGFloat = 8
    static let reusableListViewSearchTextDebounce: Int = 500
    static let filterButtonsHighLightColor: UIColor = UIColor(red: 0.10, green: 0.25, blue: 0.56, alpha: 0.65)
    static let searchBarPlaceHolder = "Search"
    static let MoviesCollectionCellidentifier = "MoviesCollectionViewCell"
    static let systemIconWidht: CGFloat = 35
    static let systemIconHeight: CGFloat = 35
    static let moviePosterURL: String = "https://image.tmdb.org/t/p/w500"
}

//MARK: - FilterButtonsDelegate
@objc protocol FilterButtonsDelegate: AnyObject {
    /// Tells the delegate which filter button was clicked.
    /// - Parameter buttonTitle: The title of the button that was clicked.
    func buttonClicked(with buttonTitle: String)
}

@objc protocol SearchBarTextFieldTextPublisherDelegate: AnyObject {
    /// Notifies the delegate that the search bar text has been published.
    /// - Parameter text: The text published by the search bar.
    func searchBarTextPublished(text: String)
}

//MARK: - ReusableListViewProtocol
@objc protocol ReusableListViewProtocol: AnyObject {
    /// Reloads the data for the collection view.
    func reloadCollectionViewSections()
    
    /// Reloads the items at the given index paths in the collection view.
    /// - Parameter idextPath: The index paths of the items to reload.
    func reloadCellItems(at idextPath: [IndexPath])
    
    /// Returns the index path for the given cell.
    /// - Parameter cell: The cell to get the index path for.
    /// - Returns: The index path of the cell.
    func getIndexPathOfCell(for cell: UICollectionViewCell) -> IndexPath
    
    /// Resets the collection view position with the given parameters.
    /// - Parameters:
    ///   - x: The x position to reset to.
    ///   - y: The y position to reset to.
    ///   - animation:  Whether to animate the reset.
    func resetCollectionViewPosition(with x: CGFloat, on y: CGFloat, animation: Bool)
    
    /// Sets up the search bar with the given delegate.
    /// - Parameter delegate: The delegate for the search bar.
    func setUpSearchBar(with delegate: UISearchBarDelegate)
    
    ///  Sets up the collection view with the given delegates and data source.
    /// - Parameters:
    ///   - delegate: The collection view delegate.
    ///   - dataSource: The collection view data source.
    func setUpCollectionView(with delegate: UICollectionViewDelegate, with dataSource: UICollectionViewDataSource)
    
    /// Displays filter buttons with the given titles.
    /// - Parameter buttonTitles: The titles for the filter buttons.
    func filterButtons(buttonTitles: [String])
    
    /// Sets up the filter button delegate.
    /// - Parameter delegate: The filter buttons delegate.
    func setUpFilterButtonDelegate(for delegate: FilterButtonsDelegate)
    
    func setUpSearchBarTextFieldDelegate(for delegate: SearchBarTextFieldTextPublisherDelegate)
}

class ReusableListView: UIView {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var filterBarView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    private var stackView: UIStackView?
    private var cancellables: [AnyCancellable] = []
    weak var filterButtonsDelegate: FilterButtonsDelegate?
    weak var searchBarTextFiledPublisherDelegate: SearchBarTextFieldTextPublisherDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setUpView()
        loadSearchBarTextFiledPublisher()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
        setUpView()
        loadSearchBarTextFiledPublisher()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: Constants.reusableViewNibName) else { return }
        
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func loadSearchBarTextFiledPublisher() {
        searchBar.searchTextField.publisher
            .debounce(for: .milliseconds(ReusableListViewConstants.reusableListViewSearchTextDebounce), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                
                self?.searchBarTextFiledPublisherDelegate?.searchBarTextPublished(text: text)
        }.store(in: &cancellables)
    }
    
    private func setUpView() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = ReusableListViewConstants.searchBarPlaceHolder
        searchBar.barStyle = .black
        filterBarView.addSubview(searchBar)

        searchBar.leadingAnchor.constraint(equalTo: filterBarView.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: filterBarView.trailingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: filterBarView.safeAreaLayoutGuide.topAnchor).isActive = true

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        filterBarView.addSubview(scrollView)

        scrollView.leadingAnchor.constraint(equalTo: filterBarView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: filterBarView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: filterBarView.bottomAnchor).isActive = true

        stackView = UIStackView()
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        stackView?.axis = .horizontal
        stackView?.alignment = .center
        stackView?.spacing = ReusableListViewConstants.reusableListViewStackViewSpacing
        scrollView.addSubview(stackView ?? UIStackView())

        stackView?.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                           constant: ReusableListViewConstants.stackViewLeadingAnchorConstraint).isActive = true
        stackView?.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                            constant: ReusableListViewConstants.stackViewTrailingAnchorConstraint).isActive = true
        stackView?.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView?.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView?.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    }
    
    private func resetButtons(_ ignoreButton: UIButton) {
        guard let superview = ignoreButton.superview else { return }
        
        for case let button in superview.subviews {
            if button != ignoreButton {
                button.backgroundColor = .clear
            }
        }
    }
    
    private func highlightButton(_ button: UIButton) {
        button.backgroundColor = ReusableListViewConstants.filterButtonsHighLightColor
    }
    
    // MARK: - Action Methods
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let senderTitle = sender.currentTitle else { return }
        
        resetButtons(sender)
        
        if sender.backgroundColor == ReusableListViewConstants.filterButtonsHighLightColor {
            sender.backgroundColor = .clear
            return
        }
        
        highlightButton(sender)
        filterButtonsDelegate?.buttonClicked(with: senderTitle)
    }
    
}

//MARK: - ReusableListViewProtocol
extension ReusableListView: ReusableListViewProtocol {
    
    func filterButtons(buttonTitles: [String]) {
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.backgroundColor = .clear
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: ReusableListViewConstants.filterButtonHeightAnchorConstraint).isActive = true
            button.layer.cornerRadius = ReusableListViewConstants.filterButtonLayerCornerRadius
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: ReusableListViewConstants.filterButtonTitleLabelFontSize)
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            stackView?.addArrangedSubview(button)
        }
    }
    
    func setUpFilterButtonDelegate(for delegate: FilterButtonsDelegate) {
        filterButtonsDelegate = delegate
    }
    
    func setUpSearchBarTextFieldDelegate(for delegate: SearchBarTextFieldTextPublisherDelegate) {
        searchBarTextFiledPublisherDelegate = delegate
    }

    func reloadCollectionViewSections() {
        collectionView.reloadSections(IndexSet(integer: CollectionViewDataSourceConstants.collectionViewReloadSectionsInteger))
    }

    func reloadCellItems(at idextPath: [IndexPath]) {
        collectionView.reloadItems(at: idextPath)
    }

    func getIndexPathOfCell(for cell: UICollectionViewCell) -> IndexPath {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return IndexPath()
        }

        return indexPath
    }

    func resetCollectionViewPosition(with x: CGFloat, on y: CGFloat, animation: Bool) {
        collectionView.setContentOffset(CGPoint(x: x, y: y), animated: animation)
    }

    func setUpSearchBar(with delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }

    func setUpCollectionView(with delegate: UICollectionViewDelegate, with dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.register(CollectionViewReusableCell.self, forCellWithReuseIdentifier: ReusableListViewConstants.MoviesCollectionCellidentifier)
    }
}
