//
//  PieChartViewController.swift
//  JPS
//
//  Created by Jerry U. on 9/28/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa
import CorePlot

class PieChartViewController: NSViewController {
    
    @IBOutlet var hostView: CPTGraphHostingView!
    var mainView: MMPD!
    var mainData: [(key: String, value: Double)]!
    var cls = [(r: CGFloat, g: CGFloat, b: CGFloat)]()
    dynamic var mDay : String = ""
    dynamic var lDay : String = "THE DAY WHEN YOUR INNER BEAST AWAKENS"
    
    // MARK - Activities
    @IBOutlet var a1: NSTextField!
    @IBOutlet var a2: NSTextField!
    @IBOutlet var a3: NSTextField!
    @IBOutlet var a4: NSTextField!
    @IBOutlet var a5: NSTextField!
    @IBOutlet var avgJPS: NSTextField!
    
    // MARK - Duration
    @IBOutlet var d1: NSTextField!
    @IBOutlet var d2: NSTextField!
    @IBOutlet var d3: NSTextField!
    @IBOutlet var d4: NSTextField!
    @IBOutlet var d5: NSTextField!
    
    // MARK - Small Circles
    @IBOutlet var sc1: NSBox!
    @IBOutlet var sc2: NSBox!
    @IBOutlet var sc3: NSBox!
    @IBOutlet var sc4: NSBox!
    @IBOutlet var sc5: NSBox!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        mainView = self.view as! MMPD
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        //        initPlot()
    }
    
    func initPlot(with: String = "MP") {
        let day = with == "MP" ? self.mainView.jsond["top"][0].stringValue
            : self.mainView.jsond["top"].arrayValue.last?.stringValue
        
        if with != "MP" {
            self.lDay = "AND \(userHandler.usn) RESTED ON THE \(self.nth(day: day!)) DAY".uppercased()
        } else {
            self.lDay = "THE DAY WHEN YOUR INNER BEAST AWAKENS"
        }
        self.mDay = (day?.uppercased())! + "S"
        let data = self.mainView.jsond["data"][day!]
        let fields = ["sh", "ud", "wh", "ph", "ih"]
        
        var poi = [String: Double]()
        for i in fields {
            poi[i] = data[i].doubleValue
        }
        let nPoi = poi.sorted {
            return $0.value > $1.value
        }
        
        self.avgJPS.stringValue = String.init(format: "Average JPS of %0.2f%%", data["jps"].floatValue)
        
        self.mainData = nPoi
        let colors : [[CGFloat]] = [[0.92, 0.28, 0.25], [0.06, 0.80, 0.48], [0.22, 0.33, 0.49], [0.98, 0.8, 0.2], [0.15, 0.47, 0.98]].shuffled()
        
        cls.removeAll()
        self.cls.append((colors[0][0], colors[0][1], colors[0][2]))
        self.cls.append((colors[1][0], colors[1][1], colors[1][2]))
        self.cls.append((colors[2][0], colors[2][1], colors[2][2]))
        self.cls.append((colors[3][0], colors[3][1], colors[3][2]))
        self.cls.append((colors[4][0], colors[4][1], colors[4][2]))
        
        
        configureHostView()
        configureGraph()
        configureChart()
        configureLegend()
        
        self.a1.stringValue = (__Act.init(rawValue: nPoi[0].key)?.v())!
        self.a2.stringValue = (__Act.init(rawValue: nPoi[1].key)?.v())!
        self.a3.stringValue = (__Act.init(rawValue: nPoi[2].key)?.v())!
        self.a4.stringValue = (__Act.init(rawValue: nPoi[3].key)?.v())!
        self.a5.stringValue = (__Act.init(rawValue: nPoi[4].key)?.v())!
        
        self.d1.stringValue = hms(seconds: Int(nPoi[0].value * 3600))
        self.d2.stringValue = hms(seconds: Int(nPoi[1].value * 3600))
        self.d3.stringValue = hms(seconds: Int(nPoi[2].value * 3600))
        self.d4.stringValue = hms(seconds: Int(nPoi[3].value * 3600))
        self.d5.stringValue = hms(seconds: Int(nPoi[4].value * 3600))
        
        
        self.sc1.cornerRadius = self.sc1.frame.height / 2
        self.sc1.borderColor = NSColor(red: cls[0].r, green: cls[0].g, blue: cls[0].b, alpha: 1.0)
        self.sc1.fillColor = NSColor(red: cls[0].r, green: cls[0].g, blue: cls[0].b, alpha: 1.0)
        
        self.sc2.cornerRadius = self.sc1.frame.height / 2
        self.sc2.borderColor = NSColor(red: cls[1].r, green: cls[1].g, blue: cls[1].b, alpha: 1.0)
        self.sc2.fillColor = NSColor(red: cls[1].r, green: cls[1].g, blue: cls[1].b, alpha: 1.0)
        
        self.sc3.cornerRadius = self.sc1.frame.height / 2
        self.sc3.borderColor = NSColor(red: cls[2].r, green: cls[2].g, blue: cls[2].b, alpha: 1.0)
        self.sc3.fillColor = NSColor(red: cls[2].r, green: cls[2].g, blue: cls[2].b, alpha: 1.0)
        
        self.sc4.cornerRadius = self.sc1.frame.height / 2
        self.sc4.borderColor = NSColor(red: cls[3].r, green: cls[3].g, blue: cls[3].b, alpha: 1.0)
        self.sc4.fillColor = NSColor(red: cls[3].r, green: cls[3].g, blue: cls[3].b, alpha: 1.0)
        
        self.sc5.cornerRadius = self.sc1.frame.height / 2
        self.sc5.borderColor = NSColor(red: cls[4].r, green: cls[4].g, blue: cls[4].b, alpha: 1.0)
        self.sc5.fillColor = NSColor(red: cls[4].r, green: cls[4].g, blue: cls[4].b, alpha: 1.0)
    }
    
    func configureHostView() {
        hostView.allowPinchScaling = false
        
    }
    
    func configureGraph() {
        // 1 - Create and configure the graph
        let graph = CPTXYGraph(frame: hostView.bounds)
        hostView.hostedGraph = graph
        graph.paddingLeft = 0.0
        graph.paddingTop = 0.0
        graph.paddingRight = 0.0
        graph.paddingBottom = 0.0
        graph.axisSet = nil
        
        // 2 - Create text style
        let textStyle: CPTMutableTextStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.fontName = "HelveticaNeue-Bold"
        textStyle.fontSize = 15.0
        textStyle.textAlignment = .center
        
        // 3 - Set graph title and text style
        graph.title = "Activity 3.142 Chart"
        graph.titleTextStyle = textStyle
        graph.titlePlotAreaFrameAnchor = CPTRectAnchor.top
    }
    
    func configureChart() {
        // 1 - Get a reference to the graph
        let graph = hostView.hostedGraph!
        
        // 2 - Create the chart
        let pieChart = CPTPieChart()
        pieChart.delegate = self
        pieChart.dataSource = self
        pieChart.pieRadius = (min(hostView.bounds.size.width, hostView.bounds.size.height) * 0.7) / 2
        pieChart.identifier = NSString(string: graph.title!)
        pieChart.startAngle = CGFloat(Double.pi/4)
        pieChart.sliceDirection = .clockwise
        pieChart.labelOffset = -0.6 * pieChart.pieRadius
        
        // 3 - Configure border style
        let borderStyle = CPTMutableLineStyle()
        borderStyle.lineColor = CPTColor.white()
        borderStyle.lineWidth = 2.0
        pieChart.borderLineStyle = borderStyle
        
        // 4 - Configure text style
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.white()
        textStyle.textAlignment = .center
        pieChart.labelTextStyle = textStyle
        
        // 5 - Add chart to graph
        graph.add(pieChart)
    }
    
    func configureLegend() {
    }
    
    func hms (seconds : Int) -> String {
        let (h, m, _) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        return "\(h)h \(m)m"
    }
    
    func nth(day: String) -> String {
        switch day.lowercased() {
        case "monday":
            return "1st"
        case "tuesday":
            return "2nd"
        case "wednesday":
            return "3rd"
        case "thursday":
            return "4th"
        case "friday":
            return "5th"
        case "saturday":
            return "6th"
        default:
            return "7th"
        }
    }
}

extension PieChartViewController: CPTPieChartDataSource, CPTPieChartDelegate {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return 5
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        return self.mainData[Int(idx)].value
    }
    
    func dataLabel(for plot: CPTPlot, record idx: UInt) -> CPTLayer? {
        let str = __Act.init(rawValue: self.mainData[Int(idx)].key)!
        let layer = CPTTextLayer(text: str.v())
        layer.textStyle = plot.labelTextStyle
        return layer
    }
    
    func sliceFill(for pieChart: CPTPieChart, record idx: UInt) -> CPTFill? {
        return CPTFill(color: CPTColor(componentRed:cls[Int(idx)].r, green:cls[Int(idx)].g, blue:cls[Int(idx)].b, alpha:1.00))
    }
    
    func legendTitle(for pieChart: CPTPieChart, record idx: UInt) -> String? {
        return nil
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

enum __Act: String {
    case UD = "ud"
    case IH = "ih"
    case WH = "wh"
    case PH = "ph"
    case SH = "sh"
    
    func v() -> String! {
        switch self {
        case .UD:
            return "Undocumented"
        case .IH:
            return "Inactive"
        case .WH:
            return "Working"
        case .PH:
            return "Studying"
        case .SH:
            return "Sleeping"
        }
    }
}

