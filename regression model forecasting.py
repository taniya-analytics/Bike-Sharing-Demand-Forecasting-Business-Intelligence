import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

# Load the dataset
df = pd.read_excel("PYTHON PROGRAMS/Python/PandasAPP/New captial share dataset.xlsx")

# Drop irrelevant or check columns
df = df.drop(columns=['casual_users', 'registered_users', 'windspeed_outlier',
                      'is_holiday_check', 'is_weekday_check', 'weather_situation_check'])

# Encode binary columns
df['is_holiday'] = df['is_holiday'].map({'NO': 0, 'YES': 1})
df['is_weekday'] = df['is_weekday'].map({'NO': 0, 'YES': 1})

# Encode 'weather_situation' if it's a string
if df['weather_situation'].dtype == 'object':
    df['weather_situation'] = df['weather_situation'].astype('category').cat.codes

# Encode 'day_name' using one-hot encoding
df = pd.get_dummies(df, columns=['day_name'], drop_first=True)

# Define features and target
features = ['temp_celsius', 'humidity_percent', 'windspeed_kph',
            'weather_situation', 'is_holiday', 'is_weekday'] + \
           [col for col in df.columns if col.startswith('day_name_')]

X = df[features]
y = df['total_users']

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train regression model
model = LinearRegression()
model.fit(X_train, y_train)

# Predictions
y_pred = model.predict(X_test)

# Evaluation
mse = mean_squared_error(y_test, y_pred)
rmse = mse ** 0.5  # Manual square root to avoid version issue

print(f"R² Score: {r2_score(y_test, y_pred):.2f}")
print(f"RMSE: {rmse:.2f}")

# Plot
plt.figure(figsize=(8, 5))
sns.scatterplot(x=y_test, y=y_pred)
plt.xlabel("Actual Users")
plt.ylabel("Predicted Users")
plt.title("Actual vs Predicted Bike Users")
plt.grid(True)
plt.show()

# Save results
results = pd.DataFrame({'Actual': y_test, 'Predicted': y_pred})
results.to_excel("bike_demand_forecast_results.xlsx", index=False)


print("✅ Forecast results saved to 'bike_demand_forecast_results.xlsx'")
print(results.head())

