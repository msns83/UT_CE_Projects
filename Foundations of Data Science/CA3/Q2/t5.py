import pandas as pd
import numpy as np
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split, RandomizedSearchCV, RepeatedKFold
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

def load_data():
    train = pd.read_csv('./regression-dataset-train.csv', dayfirst=True, parse_dates=['date'])
    test  = pd.read_csv('./regression-dataset-test-unlabeled.csv', dayfirst=True, parse_dates=['date'])
    return train, test

def feature_engineering(df):
    df = df.copy()
    df['month'] = df['date'].dt.month
    df['weekday'] = df['date'].dt.weekday
    df['day_of_year'] = df['date'].dt.dayofyear
    df['week_of_year'] = df['date'].dt.isocalendar().week
    df['quarter'] = df['date'].dt.quarter
    df['is_month_start'] = df['date'].dt.is_month_start.astype(int)
    df['is_month_end'] = df['date'].dt.is_month_end.astype(int)
    df['is_weekend'] = (df['weekday'] >= 5).astype(int)

    df['month_sin']  = np.sin(2*np.pi*df['month']/12)
    df['month_cos'] = np.cos(2*np.pi*df['month']/12)
    df['wd_sin']  = np.sin(2*np.pi*df['weekday']/7)
    df['wd_cos'] = np.cos(2*np.pi*df['weekday']/7)
    df['doy_sin'] = np.sin(2*np.pi*df['day_of_year']/365)
    df['doy_cos'] = np.cos(2*np.pi*df['day_of_year']/365)
    df['woy_sin'] = np.sin(2*np.pi*df['week_of_year']/52)
    df['woy_cos'] = np.cos(2*np.pi*df['week_of_year']/52)
    df['qtr_sin'] = np.sin(2*np.pi*df['quarter']/4)
    df['qtr_cos'] = np.cos(2*np.pi*df['quarter']/4)

    df['temp_hum'] = df['temperature'] * df['humidity']
    df['temp_sq'] = df['temperature'] ** 2
    df['hum_sq']  = df['humidity'] ** 2
    df['wind_hum'] = df['wind_speed'] * df['humidity']

    return df.drop(['date','month','weekday','day_of_year','week_of_year','quarter'], axis=1)

def build_preprocessor():

    cat_cols = [
        'season_id','year','is_holiday','is_workingday',
        'weather_condition','is_month_start','is_month_end','is_weekend'
    ]

    def infer(transformer, X):
        all_cols = list(X.columns)
        num = [c for c in all_cols if c not in cat_cols + ['id','total_users']]
        return ColumnTransformer([
            ('num',   StandardScaler(), num),
            ('cat',   OneHotEncoder(sparse_output=False,handle_unknown='ignore'), cat_cols)
        ])
    return infer

def evaluate(y_true, y_pred):
    mse  = mean_squared_error(y_true, y_pred)
    rmse = np.sqrt(mse)
    mae  = mean_absolute_error(y_true, y_pred)
    r2   = r2_score(y_true, y_pred)
    mape = np.mean(np.abs((y_true - y_pred) /
             np.where(y_true==0,1,y_true))) * 100
    print(f"MSE:  {mse:.2f}")
    print(f"RMSE: {rmse:.2f}")
    print(f"MAE:  {mae:.2f}")
    print(f"MAPE: {mape:.2f}%")
    print(f"R2:   {r2:.3f}")

def main():
    train, test = load_data()
    train = feature_engineering(train)
    test  = feature_engineering(test)

    y        = train.pop('total_users')
    X        = train.drop('id', axis=1)
    ids      = test['id']
    X_test   = test.drop('id', axis=1)

    X_tr, X_val, y_tr, y_val = train_test_split(X, y, test_size=0.2, random_state=42)

    pre = build_preprocessor()(None, X_tr)

    pipe = Pipeline([('pre', pre), ('model', RandomForestRegressor(random_state=42, n_jobs=-1))])

    param_dist = {
        'model__n_estimators':      [200,500,1000],
        'model__max_depth':         [None,10,20],
        'model__max_features':      ['sqrt','log2',0.5],
        'model__min_samples_split': [2,5,10],
        'model__min_samples_leaf':  [1,2,5],
        'model__bootstrap':         [True, False]
    }

    cv = RepeatedKFold(n_splits=5, n_repeats=2, random_state=42)

    search = RandomizedSearchCV(
        pipe, param_dist, n_iter=40,
        cv=cv, scoring='neg_root_mean_squared_error',
        n_jobs=-1, verbose=1, random_state=42
    )

    search.fit(X_tr, y_tr)

    print("Best RF params:", search.best_params_)

    preds_val = search.predict(X_val)

    print("\nValidation metrics:")
    evaluate(y_val, preds_val)

    best = search.best_estimator_
    best.fit(X, y)
    preds_test = best.predict(X_test).clip(0)
    pd.DataFrame({'id': ids, 'label': preds_test}) \
      .to_csv('./t55.csv', index=False, float_format='%.3f')


main()