//
//  TvSeriesDetailsViewController.swift
//  MovieCave
//
//  Created by Admin on 11.01.24.
//

import UIKit
import Combine

class TvSeriesDetailsViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet private weak var bigPosterImageView: UIImageView!
    @IBOutlet private weak var castStackView: UIStackView!
    @IBOutlet private weak var describtionImageView: UIImageView!
    @IBOutlet private weak var describtionLabel: UILabel!
    @IBOutlet private weak var genreView: UIView!
    @IBOutlet private weak var starRaitingLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var trailerStackView: UIStackView!
    
    //MARK: - Properties
    var viewModel: TvSeriesDetailsProtocol?
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

extension TvSeriesDetailsViewController: TrailerViewDelegate {
    
    func setUpBinders() {
        viewModel?.mediaDetails.sink { [weak self] seriesDetails in
            guard let self,
                  let seriesDetails else { return }
            
            DispatchQueue.main.async {
                self.bigPosterImageView.downloaded(from: ReusableListViewConstants.moviePosterURL + seriesDetails.bigPoster, contentMode: .scaleAspectFill)
                self.starRaitingLabel.text = seriesDetails.avrgVote
                self.yearLabel.text = seriesDetails.releaseDate
                self.movieTitleLabel.text = seriesDetails.title
                self.describtionImageView.downloaded(from: ReusableListViewConstants.moviePosterURL + seriesDetails.poster)
                self.describtionLabel.text = seriesDetails.overview
                self.setUpGenreLabels(with: seriesDetails.gernes)
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
    
    func trailerViewDidTapPlayButton(_ trailerView: TrailerView) {
        trailerView.playMovieTrailer(in: self.view)
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
    
}
