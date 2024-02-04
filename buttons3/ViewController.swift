//
//  ViewController.swift
//  buttons3
//
//  Created by Alexander Zhuchkov on 04.02.2024.
//

import UIKit

/**
 Добавить на экран 3 кнопки с разным текстом. По нажатию на третью кнопку показывать модальный контроллер.

 - Кнопки должны быть адаптивные, под разный текст - разная ширина. Отступ внутри кнопки от контента 10pt по вертикали и 14pt по горизонтали.
 - По нажатию анимированно уменьшать кнопку. Когда отпускаешь - кнопка возвращается к оригинальному размеру. Анимация должна быть прерываемая, например, кнопка возвращается к своему размеру, а в процессе анимации снова нажать на кнопку - анимация пойдет из текущего размера, без скачков.
 - Справа от текста поставить иконку. Использовать системный imageView в классе кнопки, создавать свою imageView нельзя. Расстояние между текстом и иконкой 8pt.
 - Когда показывается модальный контроллер, кнопка красится — фон в .systemGray2, а текст и иконка в .systemGray3.⚠️Нельзя привязываться к методам жизненного цикла контроллера.
 */

class ViewController: UIViewController {
    
    
    // MARK: - Subviews
    private let button1 = Button(title: "First button")
    private let button2 = Button(title: "Second Medium Button")
    private lazy var button3: Button = {
        let button = Button(title: "Third Button", primaryAction: .init(title: "", handler: { [weak self] _ in
            self?.showModalViewController()
        }))
    
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.alignment = .center
        
        // Subviews
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        
        return stackView
    }()
    
    
    // MARK: - Helper Methods
    private func setupView() {
        
        // Subviews
        view.addSubview(stackView)
        
        // Layout Subviews
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    private func showModalViewController() {
        let viewController = ModalViewController()
        self.present(viewController, animated: true)
    }
}

// MARK: - UIViewController Life Cycle
extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
    }
}

// MARK: - Custom Button
class Button: UIButton {
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.33, delay: 0, options: .allowUserInteraction) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.7, y: 0.7) : .identity
            }
        }
    }
    
    // MARK: - Initialization
    init(title: String, primaryAction: UIAction? = nil) {
        
        super.init(frame: .zero)
        
        // Configuration
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = .init(top: 10, leading: 14, bottom: 10, trailing: 14)
        configuration.imagePadding = 8
        configuration.imagePlacement = .trailing
        self.configuration = configuration
        
        // Action
        if let action = primaryAction {
            self.addAction(action, for: .touchUpInside)
        }
        
        // Title
        setTitle(title, for: .normal)
        
        // Image
        setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        imageView?.tintAdjustmentMode = .normal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override func tintColorDidChange() {
        let dimmedBackgroundColor: UIColor = .systemGray2
        let dimmedForegroundColor: UIColor = .systemGray3
    
        // Dimmed
        if tintAdjustmentMode == .dimmed {
            
            configuration?.background.backgroundColor = dimmedBackgroundColor
            setNeedsUpdateConfiguration()
            
            titleLabel?.textColor = dimmedForegroundColor
            imageView?.tintColor = dimmedForegroundColor
            
        } else {
            configuration?.background.backgroundColor = nil
            setNeedsUpdateConfiguration()
        }
    }
    
}

