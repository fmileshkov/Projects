//
//  MovieDetailsScreenViewController.swift
//  MovieCave
//
//  Created by Admin on 2.10.23.
//

import Combine
import UIKit

class MoviesDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet private weak var trailerStackView: UIStackView!
    @IBOutlet private weak var bigPosterImageView: UIImageView!
    @IBOutlet private weak var castStackView: UIStackView!
    @IBOutlet private weak var genreView: UIView!
    @IBOutlet private weak var favoritesStarLabel: UILabel!
    @IBOutlet private weak var movieYearLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var describtionImage: UIImageView!
    @IBOutlet private weak var describtionLabel: UILabel!
    
    //MARK: - Properties
    var viewModel: MediaDetailsScreenViewModelProtocol?
    private var cancellables: [AnyCancellable] = []

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

//MARK: - View Elements setUp
extension MoviesDetailsViewController: TrailerViewDelegate {

    func setUpBinders() {
        viewModel?.mediaDetails.sink { [weak self] movieDetails in
            guard let self,
                  let movieDetails else { return }
            
            DispatchQueue.main.async {
                self.bigPosterImageView.downloaded(from: ReusableListViewConstants.moviePosterURL + movieDetails.bigPoster, contentMode: .scaleAspectFill)
                self.favoritesStarLabel.text = movieDetails.avrgVote
                self.movieYearLabel.text = movieDetails.releaseDate
                self.movieTitleLabel.text = movieDetails.title
                self.describtionImage.downloaded(from: ReusableListViewConstants.moviePosterURL + movieDetails.poster)
                self.describtionLabel.text = movieDetails.overview
                self.setUpGenreLabels(with: movieDetails.gernes)
            }
        }.store(in: &cancellables)

        viewModel?.mediaCast.sink { [weak self] castArray in
            guard let self,
                  let castArray else { return }

            DispatchQueue.main.async {
                self.setUpCast(with: castArray)
            }
        }.store(in: &cancellables)

        viewModel?.mediaVideos.sink { [weak self] videos in
            guard let self,
                  let videos else { return }
            
            DispatchQueue.main.async {
                self.setUpTrailers(with: videos)
            }
        }.store(in: &cancellables)
        
        viewModel?.popUpMessage.sink { [weak self] message in
            guard let self,
                  let message else { return }
            
            self.view.addSubview(PopUpView(frame: self.view.bounds, inVC: self, messageLabelText: message))
        }.store(in: &cancellables)

    }

    func setUpGenreLabels(with genres: [String]) {
        let genreLabelsView: GenreLabelsViewProtocol = GenreLabelsView()
        genreView.addSubview(genreLabelsView)
        genreLabelsView.frame = genreView.bounds
        genreLabelsView.setUpGenreLabels(with: genres)
    }

    func setUpCast(with castArray: [MediaCast]) {
        let castView: PopulatedCastViewProtocol = PopulatedCastView()
        castStackView.addArrangedSubview(castView)
        castView.frame = castStackView.bounds
        castView.setUpCast(with: castArray)
    }

    func setUpTrailers(with trailers: [MediaVideos]) {
        let trailersView: TrailerVideosViewProtocol = TrailerVideosView()
        trailerStackView.addArrangedSubview(trailersView)
        trailersView.frame = genreView.bounds
        trailersView.setUpTrailers(with: trailers, trailerViewDelegate: self)
    }
    
    func trailerViewDidTapPlayButton(_ trailerView: TrailerView) {
        trailerView.playMovieTrailer(in: self.view)
    }

}
