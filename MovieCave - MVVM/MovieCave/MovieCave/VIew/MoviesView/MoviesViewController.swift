//
//  MoviesViewController.swift
//  MovieCave
//
//  Created by Admin on 21.09.23.
//

import UIKit
import Combine

class MoviesViewController: UIViewController, SpinnerProtocol {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var movieView: ReusableListViewProtocol!
    
    //MARK: - Properties
    var viewModel: MoviesViewModelProtocol?
    var spinnerView: UIView?
    private var favoriteButton: UIButton!
    private var popUp: PopUpView!
    private var cancellables: [AnyCancellable] = []
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        movieView.filterButtons(buttonTitles: [Constants.mostPopularFilterButton,
                                                  Constants.upComingFilterButton,
                                                  Constants.ratingFilterButton,
                                                  Constants.newestFilterButton])
        setUpBinders()
        setUpDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Private Methods
    private func setUpBinders() {
        viewModel?.favoriteButtonIndex.sink { [weak self] index in
            guard let self,
                  let index else { return }
            
            let indexPath = IndexPath(row: index, section: 0)
            self.movieView.reloadCellItems(at: [indexPath])
        }.store(in: &cancellables)
        
        viewModel?.resetPosition.sink { [weak self] makeReset in
            guard let self,
                  makeReset else { return }
            
            self.showSpinner()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.movieView.resetCollectionViewPosition(with: 0, on: 0, animation: true)
            }
            
        }.store(in: &cancellables)

        viewModel?.fetchingDataSuccession.sink { [weak self] success in
            guard let self,
                  success else { return }
            
            self.removeSpinner()
            DispatchQueue.main.async {
                self.movieView.reloadCollectionViewSections()
            }
        }.store(in: &cancellables)
        
        viewModel?.popUpMessage.sink { [weak self] message in
            guard let self,
                  let message else { return }
            
            DispatchQueue.main.async {
                self.popUp = PopUpView(frame: self.view.bounds, inVC: self, messageLabelText: message)
                self.view.addSubview(self.popUp)
            }
            
        }.store(in: &cancellables)
    }
}

//MARK: - FilterButtonsDelegate
extension MoviesViewController: FilterButtonsDelegate {
    func buttonClicked(with buttonTitle: String) {
        viewModel?.filterMovies(buttonTitle)
    }
}

//MARK: - CollectionViewDelegate & DataSource & DelegateFlowLayout
extension MoviesViewController {
    
    private func setUpDelegates() {
        guard let viewModel else { return }
        
        movieView.setUpFilterButtonDelegate(for: self)
        movieView.setUpSearchBarTextFieldDelegate(for: self)
        movieView.setUpCollectionView(with: viewModel.dataSource, with: viewModel.dataSource)
        movieView.setUpSearchBar(with: self)
    }
}

//MARK: - UISearchBarDelegate
extension MoviesViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        
        self.showSpinner()
        viewModel?.performSearch(with: searchBarText)
    }
}

//MARK: - SearchBarTextFieldTextPublisherDelegate
extension MoviesViewController: SearchBarTextFieldTextPublisherDelegate {
    func searchBarTextPublished(text: String) {
        self.showSpinner()
        viewModel?.performSearch(with: text)
    }
}
