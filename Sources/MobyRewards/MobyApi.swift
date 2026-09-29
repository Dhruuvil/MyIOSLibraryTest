import Foundation

public class MobyApi {
    public static let shared = MobyApi()
    private static let apiUrlString = "https://mobyads.in/moby/v4/"

    private init() {}

    // MARK: - Get Upcoming Offers
    public static func getUpcomingOffers(
        affiliateId: String,
        appShortName: String,
        secureKey: String,
        userUnique: String,
        gender: String,
        age: Int,
        deviceId: String,
        onSuccess: @escaping ([String: Any]) -> Void,
        onError: @escaping (String) -> Void
    ) {
        guard let url = URL(string: apiUrlString) else {
            DispatchQueue.main.async { onError("Invalid API URL") }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 15.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body: [String: Any] = [
            "fsAction": "getUpcommingOffer",
            "fsAffiliateId": affiliateId,
            "fsAppShortName": appShortName,
            "fsSecureKey": secureKey,
            "fsUserUnique": userUnique,
            "fsGender": gender,
            "fiAge": age,
            "fsDeviceId": deviceId
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            DispatchQueue.main.async { onError("Failed to encode request JSON: \(error.localizedDescription)") }
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { onError(error.localizedDescription) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { onError("Invalid HTTP response") }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { onError("No data returned") }
                return
            }

            let responseCode = httpResponse.statusCode
            if (200...299).contains(responseCode) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            let isError = (json["fbIsError"] as? Bool) ?? false
                            if isError {
                                let msg = (json["fsMessage"] as? String) ?? "Unknown API error"
                                onError(msg)
                            } else {
                                onSuccess(json)
                            }
                        }
                    } else {
                        DispatchQueue.main.async { onError("Invalid JSON format") }
                    }
                } catch {
                    DispatchQueue.main.async { onError("Invalid JSON response: \(error.localizedDescription)") }
                }
            } else {
                let responseStr = String(data: data, encoding: .utf8) ?? "HTTP Error \(responseCode)"
                DispatchQueue.main.async { onError("API Error \(responseCode): \(responseStr)") }
            }
        }.resume()
    }

    // MARK: - Direct Submit Quiz
    public static func directSubmitQuiz(
        adId: Int,
        deviceUniqueId: Int,
        token: String,
        userId: String,
        userContact: String,
        deviceId: String,
        isPwa: String = "no",
        onSuccess: @escaping ([String: Any]) -> Void,
        onError: @escaping (String) -> Void
    ) {
        guard let url = URL(string: apiUrlString) else {
            DispatchQueue.main.async { onError("Invalid API URL") }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 15.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "fsAction": "directSubmitQuiz",
            "fiAdId": adId,
            "device_unique_id": deviceUniqueId,
            "fsToken": token,
            "fiUserId": userId,
            "fsUserContact": userContact,
            "fsDeviceId": deviceId,
            "isPWA": isPwa
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            DispatchQueue.main.async { onError("Failed to encode request JSON: \(error.localizedDescription)") }
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { onError(error.localizedDescription) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { onError("Invalid HTTP response") }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { onError("No data returned") }
                return
            }

            let responseCode = httpResponse.statusCode
            if (200...299).contains(responseCode) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            let isError = (json["fbIsError"] as? Bool) ?? false
                            if isError {
                                let msg = (json["fsMessage"] as? String) ?? "Unknown API error"
                                onError(msg)
                            } else {
                                onSuccess(json)
                            }
                        }
                    } else {
                        DispatchQueue.main.async { onError("Invalid JSON format") }
                    }
                } catch {
                    DispatchQueue.main.async { onError("Invalid JSON response: \(error.localizedDescription)") }
                }
            } else {
                let responseStr = String(data: data, encoding: .utf8) ?? "HTTP Error \(responseCode)"
                DispatchQueue.main.async { onError("API Error \(responseCode): \(responseStr)") }
            }
        }.resume()
    }

    // MARK: - Get Active Offers
    public static func getActiveOffers(
        affiliateId: String,
        appShortName: String,
        secureKey: String,
        userUnique: String,
        gender: String,
        age: Int,
        deviceId: String,
        onSuccess: @escaping ([String: Any]) -> Void,
        onError: @escaping (String) -> Void
    ) {
        guard let url = URL(string: apiUrlString) else {
            DispatchQueue.main.async { onError("Invalid API URL") }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 15.0
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body: [String: Any] = [
            "fsAction": "getActiveOffer",
            "fsAffiliateId": affiliateId,
            "fsAppShortName": appShortName,
            "fsSecureKey": secureKey,
            "fsUserUnique": userUnique,
            "fsGender": gender,
            "fiAge": age,
            "fsDeviceId": deviceId
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            DispatchQueue.main.async { onError("Failed to encode request JSON: \(error.localizedDescription)") }
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { onError(error.localizedDescription) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { onError("Invalid HTTP response") }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { onError("No data returned") }
                return
            }

            let responseCode = httpResponse.statusCode
            if (200...299).contains(responseCode) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            let isError = (json["fbIsError"] as? Bool) ?? false
                            if isError {
                                let msg = (json["fsMessage"] as? String) ?? "Unknown API error"
                                onError(msg)
                            } else {
                                onSuccess(json)
                            }
                        }
                    } else {
                        DispatchQueue.main.async { onError("Invalid JSON format") }
                    }
                } catch {
                    DispatchQueue.main.async { onError("Invalid JSON response: \(error.localizedDescription)") }
                }
            } else {
                let responseStr = String(data: data, encoding: .utf8) ?? "HTTP Error \(responseCode)"
                DispatchQueue.main.async { onError("API Error \(responseCode): \(responseStr)") }
            }
        }.resume()
    }
}
