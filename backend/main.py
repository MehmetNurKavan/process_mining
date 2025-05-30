import pandas as pd
from datetime import datetime
import sys
import json

def load_data(file_path):
    df = pd.read_csv(file_path)
    df['Start Time'] = pd.to_datetime(df['Start Time'])
    df['End Time'] = pd.to_datetime(df['End Time'])
    return df

def calculate_case_durations(df):
    durations = df.groupby('Case ID').agg({'Start Time': 'min', 'End Time': 'max'})
    durations['Total Duration'] = durations['End Time'] - durations['Start Time']
    durations['Total Duration'] = durations['Total Duration'].astype(str)
    return durations['Total Duration'].to_dict()

def most_frequent_activities(df):
    return df['Activity Name'].value_counts().to_dict()

def average_completion_time(df):
    durations = df.groupby('Case ID').agg({'Start Time': 'min', 'End Time': 'max'})
    durations['Duration'] = durations['End Time'] - durations['Start Time']
    return str(durations['Duration'].mean())

def transition_frequency(df):
    transitions = []
    for case_id, group in df.groupby('Case ID'):
        sorted_group = group.sort_values('Start Time')
        activities = list(sorted_group['Activity Name'])
        for i in range(len(activities) - 1):
            transitions.append((activities[i], activities[i+1]))
    freq = pd.Series(transitions).value_counts().to_dict()
    return {f"{k[0]} -> {k[1]}": v for k, v in freq.items()}

def main():
    if len(sys.argv) < 2:
        print("CSV dosya yolu eksik.")
        return

    file_path = sys.argv[1]
    df = load_data(file_path)

    result = {
        "CaseDurations": calculate_case_durations(df),
        "FrequentActivities": most_frequent_activities(df),
        "AverageCompletionTime": average_completion_time(df),
        "TransitionFrequency": transition_frequency(df)
    }

    print(json.dumps(result, ensure_ascii=False))

if __name__ == "__main__":
    main()
