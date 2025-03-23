import UIKit
import SDWebImage

class PhotoGalleryViewController: UIViewController {
    
    var photos: [Photo] = []
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private let resetButton = UIButton(type: .system)
    private var isFetchingData = false // Флаг для предотвращения дублирующихся запросов
    private var currentPage = 1 // Текущая страница для подгрузки фото
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPhotos(query: "Дом", page: currentPage)
    }
    
    // Настройка интерфейса
    private func setupUI() {
        view.backgroundColor = .white
        
        searchBar.placeholder = "Search photos"
        searchBar.delegate = self
        searchBar.sizeToFit() // Фикс для UINavigationBar
        navigationItem.titleView = searchBar
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetSearch), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resetButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchPhotos(query: String, page: Int) {
        guard !isFetchingData else {
            print("Запрос уже выполняется, подождите...")
            return
        }

        isFetchingData = true
        
        // Передаем запрос и текущую страницу
        PixabayAPI.fetchPhotos(query: query, page: page) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isFetchingData = false
            }
            
            switch result {
            case .success(let fetchedPhotos):
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: fetchedPhotos) // Добавляем новые фото
                    self.collectionView.reloadData()
                    self.currentPage += 1 // Увеличиваем страницу для следующего запроса
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Ошибка загрузки: \(error.localizedDescription)")
                    self.showAlert(title: "Ошибка", message: "Не удалось загрузить фотографии. Попробуйте еще раз.")
                }
            }
        }
    }

    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showFullScreenPhoto(with photo: Photo) {
        let fullScreenVC = FullScreenPhotoViewController(photoURL: photo.url)
        navigationController?.pushViewController(fullScreenVC, animated: true)
    }

    @objc private func resetSearch() {
        searchBar.text = ""  // Очищаем текстовое поле
        photos.removeAll()   // Очищаем текущие фотографии
        collectionView.reloadData() // Перезагружаем коллекцию
        currentPage = 1  // Сбрасываем страницу
        
        // При пустом запросе загружаем все фотографии
        fetchPhotos(query: "", page: currentPage)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - scrollViewHeight * 2, !isFetchingData {
            fetchPhotos(query: searchBar.text ?? "Дом", page: currentPage)
        }
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
        cell.configure(with: photos[indexPath.item].url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.item]
        showFullScreenPhoto(with: selectedPhoto)
    }
}

extension PhotoGalleryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            photos.removeAll() // Очищаем текущие фотографии
            collectionView.reloadData() // Перезагружаем коллекцию
            currentPage = 1 // Сбрасываем страницу
            fetchPhotos(query: query, page: currentPage) // Загружаем фотографии по запросу
        } else {
            // Если текст пустой, загружаем все фотографии
            photos.removeAll()
            collectionView.reloadData()
            currentPage = 1
            fetchPhotos(query: "", page: currentPage) // Загружаем все фотографии
        }
    }
}

