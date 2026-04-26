import Foundation

struct ExchangeRateResponse: Codable {
    let rates: [String: Double]
}

class ExchangeRateService {
    static let appID = "a8ef18010821442f99de7b7440e610ae"
    
    static func fetchRates() async throws -> [String: Double] {
        let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(appID)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
        return decoded.rates
    }
}
