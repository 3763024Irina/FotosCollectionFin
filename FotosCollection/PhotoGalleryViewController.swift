import UIKit
import SDWebImage

class PhotoGalleryViewController: UIViewController {
    
    var photos: [Photo] = [] // Массив загруженных фото
    private let searchBar = UISearchBar() // Поисковая строка
    private var collectionView: UICollectionView! // Коллекция для отображения фото
    private let resetButton = UIButton(type: .system) // Кнопка сброса
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPhotos(query: "Дом") // Начальная загрузка
    }
    
    // Настройка интерфейса
    private func setupUI() {
        view.backgroundColor = .white
        
        searchBar.placeholder = "Search photos"
        searchBar.delegate = self // Назначаем делегат UISearchBar
        navigationItem.titleView = searchBar
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self // Назначаем делегат UICollectionView
        collectionView.dataSource = self // Назначаем источник данных UICollectionView
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
    
    // Функция для сброса поиска
    @objc private func resetSearch() {
        searchBar.text = ""
        photos.removeAll()
        collectionView.reloadData()
        fetchPhotos(query: "Дом") // Или другое значение по умолчанию
    }
    
    // Загрузка фотографий по запросу
    func fetchPhotos(query: String) {
        guard !query.isEmpty else {
            // Пустой запрос, можно показать ошибку или вернуть дефолтные данные
            print("Пустой запрос!")
            return
        }
        PixabayAPI.fetchPhotos(query: query) { [weak self] result in
            switch result {
            case .success(let fetchedPhotos):
                if !fetchedPhotos.isEmpty {
                    self?.photos = fetchedPhotos
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        // Здесь можно отобразить уведомление, что нет результатов
                        let alert = UIAlertController(title: "Нет результатов", message: "По запросу '\(query)' не найдено фотографий.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Ошибка загрузки фотографий: \(error.localizedDescription)")
                    // Можно также уведомить пользователя о возникшей ошибке
                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить фотографии. Попробуйте еще раз.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    // Переход на экран с полноэкранной фотографией
    private func showFullScreenPhoto(with photo: Photo) {
        let fullScreenVC = FullScreenPhotoViewController(photoURL: photo.url)
        navigationController?.pushViewController(fullScreenVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
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
        // Переход с использованием кода
        let selectedPhoto = photos[indexPath.item]
        showFullScreenPhoto(with: selectedPhoto)
    }
}

// MARK: - UISearchBarDelegate
extension PhotoGalleryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            fetchPhotos(query: query)
        }
    }
}
