import SwiftUI

struct Meal {
    var name: String
    var description: String
}

struct ContentView: View {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    @State private var selectedDateIndex = 0
    let dates = ["Hôm nay", "Ngày mai", "Ngày kia"]
    @State private var breakfastMeals: [Meal] = [
        Meal(name: "Bánh mì", description: "Bánh mì hấp vị với trứng và thịt"),
        Meal(name: "Sữa chua", description: "Sữa chua tự nhiên với trái cây"),]
    @State private var lunchMeals: [Meal] = [
        Meal(name: "Gà nướng", description: "Gà nướng với rau sống"),
        Meal(name: "Cơm", description: "Cơm trắng"),
    ]
    @State private var dinnerMeals: [Meal] = [
        Meal(name: "Súp hấp", description: "Súp hấp với thịt và rau cải"),
        Meal(name: "Salad", description: "Salad trái cây với sốt dầu và giấm"),]
    var body: some View {
        VStack {
            Text("Bữa ăn hôm nay")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            
            HStack {
                Picker("Chọn ngày", selection: $selectedDateIndex) {
                    ForEach(0..<dates.count, id: \.self) { index in
                        Text(dates[index])
                            .font(.headline)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
            }
            .padding(.horizontal, 16)
            Text(dateFormatter.string(from: currentDate))
                .font(.subheadline)
                .foregroundColor(.gray)
            Divider()
                .background(Color.gray)
                .padding(.horizontal)
            MealSection(title: "Buổi sáng", meals: $breakfastMeals)
            MealSection(title: "Buổi trưa", meals: $lunchMeals)
            MealSection(title: "Buổi tối", meals: $dinnerMeals)
            Spacer()
            Button(action: {
                self.randomizeMeals()
            }) {
                Text("Random món ăn")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    var currentDate: Date {
        let calendar = Calendar.current
        switch selectedDateIndex {
        case 1:
            return calendar.date(byAdding: .day, value: 1, to: Date())!
        case 2:
            return calendar.date(byAdding: .day, value: 2, to: Date())!
        default:
            return Date()
        }
    }
    func randomizeMeals() {
        breakfastMeals.shuffle()
        lunchMeals.shuffle()
        dinnerMeals.shuffle()
    }
}

struct MealSection: View {
    var title: String
    @Binding var meals: [Meal]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            ForEach(meals, id: \.name) { meal in
                MealRow(meal: meal)
            }
        }
        .padding(.horizontal)
    }
}

struct MealRow: View {
    var meal: Meal
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(meal.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
