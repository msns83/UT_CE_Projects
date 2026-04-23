import pandas as pd
import joblib
import mlflow
import mlflow.sklearn
import mlflow.keras
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping

def train_nn():
    print("Training Neural Network...")
    df = pd.read_pickle("./database/feature_engineered.pkl")
    target_column = 'risk_flag'
    X = df.drop(columns=[target_column, 'applicant_id'])

    categorical_cols = ['married_single', 'house_ownership', 'car_ownership', 'city', 'state']
    X = pd.get_dummies(X, columns=categorical_cols, drop_first=True)
    X.columns = X.columns.str.replace(r"[\[\]<>]", "", regex=True)

    y = df[target_column]

    X_train, X_val, y_train, y_val = train_test_split(
        X, y, test_size=0.15, random_state=42, stratify=y
    )

    model = Sequential([
        Dense(128, activation='relu', input_dim=X_train.shape[1]),
        Dropout(0.3),
        Dense(64, activation='relu'),
        Dropout(0.3),
        Dense(1, activation='sigmoid')
    ])

    model.compile(
        optimizer=Adam(learning_rate=0.001),
        loss='binary_crossentropy',
        metrics=['accuracy']
    )

    es = EarlyStopping(monitor='val_loss', patience=3, restore_best_weights=True)
    
    with mlflow.start_run(run_name="NeuralNetwork"):
        history = model.fit(
            X_train, y_train,
            validation_data=(X_val, y_val),
            epochs=10, batch_size=32, verbose=2, callbacks=[es]
        )

        val_accuracy = history.history['val_accuracy'][-1]
        mlflow.log_param("optimizer", "Adam")
        mlflow.log_param("epochs", 10)
        mlflow.log_param("batch_size", 32)
        mlflow.log_metric("val_accuracy", val_accuracy)

        model.save("trained_models/nn_model.h5")
        mlflow.keras.log_model(model, "nn_model")
        print("Neural network model saved and logged to MLflow.")

def train_model():
    print("Training Random Forest...")
    df = pd.read_pickle("./database/feature_engineered.pkl")
    target_column = 'risk_flag'
    X = df.drop(columns=[target_column, 'applicant_id'])

    categorical_cols = ['married_single', 'house_ownership', 'car_ownership', 'city', 'state']
    X = pd.get_dummies(X, columns=categorical_cols, drop_first=True)
    X.columns = X.columns.str.replace(r"[\[\]<>]", "", regex=True)

    y = df[target_column]

    X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.15, random_state=42, stratify=y)

    model = RandomForestClassifier(
        n_estimators=100,
        max_depth=None,
        class_weight='balanced',
        random_state=42
    )

    with mlflow.start_run(run_name="RandomForest"):
        model.fit(X_train, y_train)
        y_val_pred = model.predict(X_val)
        val_acc = accuracy_score(y_val, y_val_pred)

        mlflow.log_param("n_estimators", 100)
        mlflow.log_param("max_depth", None)
        mlflow.log_param("class_weight", "balanced")
        mlflow.log_metric("val_accuracy", val_acc)

        joblib.dump(model, "./trained_models/random_forest.pkl")
        mlflow.sklearn.log_model(model, "random_forest_model")
        print("Random forest model saved and logged to MLflow.")

if __name__ == "__main__":
    train_model()
    train_nn()
