import Foundation
import EssentialFeed

class InMemoryFeedStore {
  private(set) var FeedCache: CachedFeed?
  private var feedImageDataCache: [URL: Data] = [:]
  
  private init(feedCache: CachedFeed? = nil) {
    self.FeedCache = feedCache
  }
}

extension InMemoryFeedStore: FeedStore {
  func deleteCachedFeed() throws {
    FeedCache = nil
  }
  
  func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
    FeedCache = CachedFeed(feed: feed, timestamp: timestamp)
  }
  
  func retrieve() throws -> CachedFeed? {
    return FeedCache
  }
}

extension InMemoryFeedStore: FeedImageDataStore {
  func insert(_ data: Data, for url: URL) throws {
    feedImageDataCache[url] = data
  }
  
  func retrieve(dataForURL url: URL) throws -> Data? {
    return feedImageDataCache[url]
  }
}

extension InMemoryFeedStore {
  static var empty: InMemoryFeedStore {
    InMemoryFeedStore()
  }
  
  static var withExpiredFeedCache: InMemoryFeedStore {
    InMemoryFeedStore(feedCache: CachedFeed(feed: [], timestamp: Date.distantPast))
  }
  
  static var withNonExpiredFeedCache: InMemoryFeedStore {
    InMemoryFeedStore(feedCache: CachedFeed(feed: [], timestamp: Date()))
  }
}
