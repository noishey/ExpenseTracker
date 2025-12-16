//
//  LineChart.swift
//  ExpenseTracker
//
//  Created by Arjun Shenoy on 16/12/25.
//

import SwiftUI
import Charts

struct LineChart: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @State private var selectedDate: Date? = nil

    // Aggregate transactions per day, then compute cumulative totals.
    private var dailyCumulative: [(date: Date, total: Double)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactionListVM.transactions) { t in
            calendar.startOfDay(for: t.dateParsed)
        }

        let dailyTotals: [(date: Date, amount: Double)] = grouped.map { (day, txs) in
            let sum = txs.reduce(0.0) { partial, t in
                let delta = t.type == TransactionType.debit.rawValue ? abs(t.amount) : -abs(t.amount)
                return partial + delta
            }
            return (day, sum)
        }
        .sorted { $0.date < $1.date }

        var running: Double = 0
        var cumulative: [(Date, Double)] = []
        for (day, sum) in dailyTotals {
            running += sum
            cumulative.append((day, running))
        }
        return cumulative
    }

    private var xDomain: ClosedRange<Date>? {
        guard let first = dailyCumulative.first?.date,
              let last = dailyCumulative.last?.date else { return nil }
        return first...last
    }

    private func value(at date: Date) -> (date: Date, total: Double)? {
        // exact day match first
        if let exact = dailyCumulative.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            return exact
        }
        // nearest by time interval
        return dailyCumulative.min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cumulative Spending")
                .font(.headline)

            if dailyCumulative.isEmpty {
                Chart {
                    ForEach(0..<7, id: \.self) { i in
                        LineMark(
                            x: .value("Day", Calendar.current.startOfDay(for: Date().addingTimeInterval(Double(i) * 86_400))),
                            y: .value("Total", Double(i) * 10.0)
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 200)
                .foregroundStyle(Color.accentColor)
                .opacity(0.4)
            } else {
                Chart {
                    // Area
                    ForEach(Array(dailyCumulative.enumerated()), id: \.offset) { _, point in
                        AreaMark(
                            x: .value("Date", point.date),
                            y: .value("Total", point.total)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.accentColor.opacity(0.35),
                                    Color.accentColor.opacity(0.05)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                    // Line
                    ForEach(Array(dailyCumulative.enumerated()), id: \.offset) { _, point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Total", point.total)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.accentColor)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }

                    // Selection rule + point + annotation
                    if let selectedDate,
                       let nearest = value(at: selectedDate) {
                        RuleMark(x: .value("Selected", nearest.date))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                            .foregroundStyle(Color.secondary)

                        PointMark(
                            x: .value("Date", nearest.date),
                            y: .value("Total", nearest.total)
                        )
                        .symbolSize(60)
                        .foregroundStyle(Color.accentColor)
                        .annotation(position: .topLeading) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(nearest.date, format: .dateTime.year().month().day())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(nearest.total, format: .currency(code: "USD"))
                                    .font(.subheadline).bold()
                            }
                            .padding(8)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .shadow(radius: 2)
                        }
                    }
                }
                .chartXScale(domain: xDomain ?? Date()...Date())
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 6)) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.year().month().day(), centered: true)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                // Enable selection by X value
                .chartXSelection(value: $selectedDate)
                // Overlay for continuous drag/hover tracking
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let origin = geo[proxy.plotAreaFrame].origin
                                        let location = CGPoint(
                                            x: value.location.x - origin.x,
                                            y: value.location.y - origin.y
                                        )
                                        if let date: Date = proxy.value(atX: location.x) {
                                            selectedDate = date
                                        }
                                    }
                            )
                    }
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview("Light") {
    let vm = TransactionListViewModel()
    vm.transactions = transactionListPreviewData
    return LineChart()
        .environmentObject(vm)
}

#Preview("Dark") {
    let vm = TransactionListViewModel()
    vm.transactions = transactionListPreviewData
    return LineChart()
        .environmentObject(vm)
        .preferredColorScheme(.dark)
}
