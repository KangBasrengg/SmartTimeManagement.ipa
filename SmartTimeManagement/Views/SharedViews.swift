import SwiftUI

extension Color {
    static let brandPrimary = Color(red: 57 / 255, green: 101 / 255, blue: 168 / 255)
    static let brandSecondary = Color(red: 75 / 255, green: 174 / 255, blue: 165 / 255)
}

struct StatTile: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(tint)
                .font(.title2)
            Text(value)
                .font(.title2.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct SectionPanel<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct EmptyState: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PriorityPill: View {
    let priority: TaskPriority

    var body: some View {
        Text(priority.rawValue)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(.white)
            .background(tint, in: Capsule())
    }

    private var tint: Color {
        switch priority {
        case .high:
            return .red
        case .medium:
            return .brandPrimary
        case .low:
            return .brandSecondary
        }
    }
}
