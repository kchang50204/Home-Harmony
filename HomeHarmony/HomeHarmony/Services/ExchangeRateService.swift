import Foundation

struct ExchangeRateResponse: Codable {
    let rates: [String: Double]
}

class ExchangeRateService {
    static let appID = "YOUR_APP_ID_HERE"
    
    static func fetchRates() async throws -> [String: Double] {
        let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(appID)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
        return decoded.rates
    }
}
