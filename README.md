This InstaStory demo is a full SwiftUI app built in just 4 hours—powered by Swift 6 and SwiftData for in-memory storage.

It features an “infinite” horizontal story carousel implemented with a LazyHStack that dynamically appends batches as you scroll.

Stories can be liked via a heart overlay, and seen/unseen state is tracked in SwiftData so that unviewed stories show a gradient ring which turns gray once viewed.

In a real-world build I’d swap in Core Data + Combine for persistence and reactive updates, but SwiftData let me move fast for this prototype.

