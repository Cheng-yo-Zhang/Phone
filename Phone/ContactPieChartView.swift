//
//  ContactPieChartView.swift
//  Phone
//
//  Created by Louis Chang on 2024/12/13.
//

import SwiftUI
import SwiftData
import Charts

struct ContactPieChartView: View {
    @Query private var contacts: [Contact]
    private let maxContacts = 10
    
    private var chartData: [(String, Double)] {
        let usedCount = Double(contacts.count)
        let remainingCount = Double(maxContacts - contacts.count)
        return [
            ("已使用", usedCount),
            ("剩餘空間", remainingCount)
        ]
    }
    
    var body: some View {
        Chart {
            ForEach(chartData, id: \.0) { item in
                SectorMark(
                    angle: .value("數量", item.1),
                    innerRadius: .ratio(0.6),
                    angularInset: 1.5
                )
                .foregroundStyle(by: .value("類型", item.0))
                .annotation(position: .overlay) {
                    Text("\(Int(item.1))")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(height: 300)
        .padding()
        .chartLegend(position: .bottom)
    }
}

#Preview {
    ContactPieChartView()
}
