//
//  ChartViewController.swift
//  Asteroid NeoStats
//
//  Created by Neel Mewada on 13/07/21.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    // MARK: - Lifecycle
    
    init(_ viewModel: ChartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.viewDelegate = self
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    // MARK: - Properties
    
    private let viewModel: ChartViewModel
    
    private var dataSet = LineChartDataSet()
    
    // MARK: - Methods
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(chartView)
        chartView.centerInSuperview()
        chartView.setDimensions(height: 300, width: 300)
        
        chartView.delegate = self
        chartView.dragEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(false)
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 10
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [5, 5]
        
        chartView.rightAxis.enabled = false
        
        let marker = BalloonMarker()
        marker.chartView = chartView
        
        chartView.legend.form = .line
        
        view.addSubview(dateRangeLabel)
        dateRangeLabel.centerX(inView: view)
        dateRangeLabel.constraints(bottom: chartView.topAnchor, spacingBottom: 10)
        
        view.addSubview(fastestAsteroidLabel)
        fastestAsteroidLabel.centerX(inView: view)
        fastestAsteroidLabel.constraints(top: chartView.bottomAnchor, spacingTop: 20)
        
        view.addSubview(closestAsteroidLabel)
        closestAsteroidLabel.centerX(inView: view)
        closestAsteroidLabel.constraints(top: fastestAsteroidLabel.bottomAnchor, spacingTop: 20)
        
        view.addSubview(averageAsteroidSizeLabel)
        averageAsteroidSizeLabel.centerX(inView: view)
        averageAsteroidSizeLabel.constraints(top: closestAsteroidLabel.bottomAnchor, spacingTop: 20)
        
        view.addSubview(filterButton)
        filterButton.centerX(inView: view)
        filterButton.constraints(bottom: dateRangeLabel.topAnchor, spacingBottom: 20)
        
        endDatePicker.date = viewModel.state.endDate
        view.addSubview(endDatePicker)
        endDatePicker.constraints(bottom: filterButton.topAnchor, right: chartView.rightAnchor, spacingBottom: 20)
        
        view.addSubview(endDatePickerLabel)
        endDatePickerLabel.constraints(left: chartView.leftAnchor)
        endDatePickerLabel.centerY(inView: endDatePicker)
        
        startDatePicker.date = viewModel.state.startDate
        view.addSubview(startDatePicker)
        startDatePicker.constraints(bottom: endDatePickerLabel.topAnchor, right: chartView.rightAnchor, spacingBottom: 20)
        
        view.addSubview(startDatePickerLabel)
        startDatePickerLabel.constraints(left: chartView.leftAnchor)
        startDatePickerLabel.centerY(inView: startDatePicker)
        
        view.addSubview(loadingIndicator)
        loadingIndicator.centerInSuperview()
        loadingIndicator.setDimensions(height: 24, width: 24)
        
        loadingIndicator.startAnimating()
    }
    
    private func configureChartData(_ startDate: Date, _ endDate: Date, _ asteroidsPerDay: [Int]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDay = Calendar.current.dateComponents([.day], from: startDate).day!
        let endDay = Calendar.current.dateComponents([.day], from: endDate).day!
        let totalDays = endDay - startDay + 1
        
        chartView.xAxis.axisMinimum = Double(startDay)
        chartView.xAxis.axisMaximum = Double(endDay)
        var chartEntries = [ChartDataEntry]()
        
        dateRangeLabel.text = dateFormatter.string(from: startDate) + " -> " + dateFormatter.string(from: endDate)
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = Double(asteroidsPerDay.max() ?? 8) + 2
        leftAxis.axisMinimum = Double(asteroidsPerDay.min() ?? 0)
        
        for i in 0...totalDays {
            if i < asteroidsPerDay.count {
                chartEntries.append(ChartDataEntry(x: Double(i + startDay), y: Double(asteroidsPerDay[i])))
            } else {
                chartEntries.append(ChartDataEntry(x: Double(i + startDay), y: 0))
            }
        }
        
        dataSet = LineChartDataSet(entries: chartEntries, label: "DataSet")
        dataSet.drawIconsEnabled = true
        configureDataSet(dataSet)
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        dataSet.fillAlpha = 1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
    
    private func configureDataSet(_ dataSet: LineChartDataSet) {
        let color = traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        
        dataSet.lineDashLengths = [5, 2.5]
        dataSet.highlightLineDashLengths = [5, 2.5]
        dataSet.setColor(color)
        dataSet.setCircleColor(color)
        dataSet.lineWidth = 1
        dataSet.circleRadius = 3
        dataSet.drawCircleHoleEnabled = false
        dataSet.valueFont = .systemFont(ofSize: 9)
        dataSet.formLineDashLengths = [5, 2.5]
        dataSet.formLineWidth = 1
        dataSet.formSize = 15
    }
    
    // MARK: - Actions
    
    @objc
    private func filterButtonTapped() {
        viewModel.viewDidApplyFilters(startDatePicker.date, endDatePicker.date)
    }
    
    // MARK: - Views
    
    private let chartView = LineChartView()
    
    private let loadingIndicator = UIActivityIndicatorView()
    
    private let startDatePickerLabel: UILabel = {
        let label = UILabel()
        label.text = "Start Date"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let startDatePicker = UIDatePicker()
    
    private let endDatePickerLabel: UILabel = {
        let label = UILabel()
        label.text = "End Date"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let endDatePicker = UIDatePicker()
    
    private let dateRangeLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        return label
    }()
    
    private let fastestAsteroidLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        return label
    }()
    
    private let closestAsteroidLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        return label
    }()
    
    private let averageAsteroidSizeLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        return label
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
}

// MARK: - State

extension ChartViewController: ChartViewModelViewDelegate {
    struct ViewState {
        var startDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        var endDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        var asteroidsPerDay: [Int] = []
        var fastestAsteroidName: String = ""
        var fastestAsteroidSpeed: Double = 0
        var closestAsteroidName: String = ""
        var closestAsteroidDistance: Double = 0
        var averageAsteroidSize: Double = 0
        var isLoading: Bool = true
    }
    
    struct ViewData {
        
    }
    
    func render(state: ViewState) {
        configureChartData(state.startDate, state.endDate, state.asteroidsPerDay)
        
        if !state.fastestAsteroidName.isEmpty {
            fastestAsteroidLabel.text = "Fastest Asteroid: \(state.fastestAsteroidName) at \(Int(state.fastestAsteroidSpeed)) km/h"
        } else {
            fastestAsteroidLabel.text = ""
        }
        
        if !state.closestAsteroidName.isEmpty {
            closestAsteroidLabel.text = "Closest Asteroid: \(state.closestAsteroidName) at \(Int(state.closestAsteroidDistance)) km"
        } else {
            closestAsteroidLabel.text = ""
        }
        
        if state.averageAsteroidSize != 0 {
            averageAsteroidSizeLabel.text = "Average Size: \(state.averageAsteroidSize) km"
        } else {
            averageAsteroidSizeLabel.text = ""
        }
        
        if state.isLoading && !loadingIndicator.isAnimating {
            loadingIndicator.startAnimating()
        } else if !state.isLoading && loadingIndicator.isAnimating {
            loadingIndicator.stopAnimating()
        }
    }
}

// MARK: - ChartViewDelegate

extension ChartViewController: ChartViewDelegate {
    
    
    
}
