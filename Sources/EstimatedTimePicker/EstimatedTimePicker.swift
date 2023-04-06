//
//  EstimatedTimePicker.swift
//  AntiMess
//
//  Created by Michael Menashe on 26/02/2023.
//

import SwiftUI

public struct EstimatedTimePicker: View {
    @Binding private var estimatedTime: Double
    
    @State private var hourSelection: Int
    @State private var minuteSelection: Int
    @State private var timeSuggets: TimeSuggets?
    
    private enum TimeSuggets: String, CaseIterable {
        case five_minute = "5 Min"
        case quarter_hour = "15 Min"
        case half_hour = "30 Min"
        case hour = "1 Hr"
        case three_hours = "3 Hr"
    }
    
    public init(estimatedTime: Binding<Double>){
        _estimatedTime = estimatedTime
        hourSelection = Int(estimatedTime.wrappedValue) / 60
        minuteSelection = Int(estimatedTime.wrappedValue) % 60
#if os(iOS)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.white.opacity(0.7))
        UISegmentedControl.appearance().backgroundColor = UIColor(.black.opacity(0.3))
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 16)] , for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black] , for: .selected)
#endif
    }
    
    public var body: some View {
        VStack {
            pickersView
            timeSuggetsView
        }
        .onAppear {
            withAnimation(.spring()) {
                if estimatedTime == 60 {
                    self.timeSuggets = .hour
                } else if estimatedTime == 180 {
                    self.timeSuggets = .three_hours
                } else if estimatedTime == 5 {
                    self.timeSuggets = .five_minute
                } else if estimatedTime == 15 {
                    self.timeSuggets = .quarter_hour
                } else if estimatedTime == 30 {
                    self.timeSuggets = .half_hour
                } else {
                    timeSuggets = nil
                }
            }
        }
    }
}

struct EstimatedTimePicker_Previews: PreviewProvider {
    static var previews: some View {
        EstimatedTimePicker(estimatedTime: .constant(5))
    }
}

extension EstimatedTimePicker {
    private var pickersView: some View {
        HStack(spacing: 0) {
            Picker("Hour", selection: $hourSelection) {
                ForEach(Range(0...24), id: \.self) { number in
                    Text("\(number)")
                        .tag(number)
                }
            }
#if os(iOS)
            .pickerStyle(.wheel)
#endif
            .overlay {
                Text("Hour")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .offset(x: 32)
            }
            .onChange(of: hourSelection) { newValue in
                estimatedTime = Double(hourSelection * 60 + minuteSelection)
                withAnimation(.spring()) {
                    if estimatedTime == 60 {
                        self.timeSuggets = .hour
                    } else if estimatedTime == 180 {
                        self.timeSuggets = .three_hours
                    } else if estimatedTime == 5 {
                        self.timeSuggets = .five_minute
                    } else if estimatedTime == 15 {
                        self.timeSuggets = .quarter_hour
                    } else if estimatedTime == 30 {
                        self.timeSuggets = .half_hour
                    } else {
                        timeSuggets = nil
                    }
                }
            }
            
            Picker("Minutes", selection: $minuteSelection) {
                ForEach(Range(0...59), id: \.self) { number in
                    Text("\(number)")
                }
            }
#if os(iOS)
            .pickerStyle(.wheel)
#endif
            .overlay {
                Text("Minutes")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .offset(x: 45)
            }
            .onChange(of: minuteSelection) { newValue in
                estimatedTime = Double(hourSelection * 60 + minuteSelection)
                withAnimation(.spring()) {
                    if estimatedTime == 5 {
                        self.timeSuggets = .five_minute
                    } else if estimatedTime == 15 {
                        self.timeSuggets = .quarter_hour
                    } else if estimatedTime == 30 {
                        self.timeSuggets = .half_hour
                    } else if estimatedTime == 60 {
                        self.timeSuggets = .hour
                    } else if estimatedTime == 180 {
                        self.timeSuggets = .three_hours
                    } else {
                        timeSuggets = nil
                    }
                }
            }
        }
    }
    private var timeSuggetsView: some View {
        HStack {
            Picker(selection: $timeSuggets) {
                ForEach(TimeSuggets.allCases, id:\.self) { time in
                    Text(time.rawValue)
                        .tag(time as TimeSuggets?)
                }
            } label: {
                Label("Time Suggets",systemImage: "calendar")
            }
            .pickerStyle(.segmented)
            .onChange(of: timeSuggets) { newValue in
                withAnimation(.spring()) {
                    switch newValue {
                    case .five_minute:
                        self.hourSelection = 0
                        self.minuteSelection = 5
                    case .quarter_hour:
                        self.hourSelection = 0
                        self.minuteSelection = 15
                    case .half_hour:
                        self.hourSelection = 0
                        self.minuteSelection = 30
                    case .hour:
                        self.hourSelection = 1
                        self.minuteSelection = 0
                    case .three_hours:
                        self.hourSelection = 3
                        self.minuteSelection = 0
                    case .none:
                        break
                    }
                }
            }
            .background {
                GeometryReader { proxy in
                    Rectangle()
                        .fill(.blue.opacity(0.5))
                        .cornerRadius(8)
                        .frame(width:(timeSuggets == .five_minute ? 1 :
                                        timeSuggets == .quarter_hour ? 2 :
                                        timeSuggets == .half_hour ? 3 :
                                        timeSuggets == .hour ? 4 :
                                        timeSuggets == .three_hours ? 5 : 0) * proxy.size.width / 5, alignment: .leading)
                }
            }
        }
        .padding(16)
    }
}
