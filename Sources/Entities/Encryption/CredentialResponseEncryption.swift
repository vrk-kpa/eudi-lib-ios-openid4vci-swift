/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation

public enum CredentialResponseEncryption: Codable {
  case notRequired
  case required(
    algorithmsSupported: [JWEAlgorithm],
    encryptionMethodsSupported: [JOSEEncryptionMethod]
  )
  
  private enum CodingKeys: String, CodingKey {
    case type
    case algorithmsSupported
    case encryptionMethodsSupported
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(String.self, forKey: .type)
    
    switch type {
    case "notRequired":
      self = .notRequired
    case "required":
      let algorithmsSupported = try container.decode([JWEAlgorithm].self, forKey: .algorithmsSupported)
      let encryptionMethodsSupported = try container.decode([JOSEEncryptionMethod].self, forKey: .encryptionMethodsSupported)
      self = .required(algorithmsSupported: algorithmsSupported, encryptionMethodsSupported: encryptionMethodsSupported)
    default:
      throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown type")
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    switch self {
    case .notRequired:
      try container.encode("not_required", forKey: .type)
    case let .required(algorithmsSupported, encryptionMethodsSupported):
      try container.encode("required", forKey: .type)
      try container.encode(algorithmsSupported, forKey: .algorithmsSupported)
      try container.encode(encryptionMethodsSupported, forKey: .encryptionMethodsSupported)
    }
  }
}
