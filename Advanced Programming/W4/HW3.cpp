#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
#include <algorithm>
using namespace std ;

constexpr int NotFound = -1 ;

struct Patient {
    string name ;
    string specialty ;
    string doctor ;
    int appointDay ;
    int appointTime ;
    int visitDay = NotFound ;
    int visitTime ;
    int visitNumber ;
    int visitCharge ; 
};
typedef vector<Patient> PatientsList ;

struct Specialty {
    string name ;
    vector<string> diseases ;
};
typedef vector<Specialty> SpecialtiesList ;

struct WorkDay {
    int day ;
    int visitNumber = 1 ;
    int startHour ;
    int endHour ;
};
typedef vector<WorkDay> DaysList ;

struct Doctor {
    string name ;
    string specialty ;
    int visitFee ;
    int visitDuration ;
    int waitTimeAvarage ;
    int firstFreeDay ;
    int firstFreeTime ;
    DaysList availableDays ;
};
typedef vector<Doctor> DoctorsList ;

struct Department {
    string specialty ;
    DoctorsList doctors ;
};
typedef vector<Department> DepartmentsList ;

int convertDayToNum(const string& inputDay){
    vector<string> days = {"Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"} ;

    for (int dayNumber = 0 ; dayNumber < days.size() ; dayNumber++)
        if (days[dayNumber] == inputDay)
            return dayNumber ;

    return NotFound ;
}

char makeCapital(char character) {
    character = (97 <= character && character <= 122) ? (char)(character-32) : character ;
    return character ;
}

bool sortedStrings(string string1, string string2) {
    if (string1.size() == 0)
        return true ;
    if (string2.size() == 0) 
        return false ;

    if (makeCapital(string1[0]) < makeCapital(string2[0]))
        return true ;
    if (makeCapital(string1[0]) == makeCapital(string2[0]))
        return sortedStrings(string1.substr(1) , string2.substr(1)) ;
    
    return false ;
}

bool patientsSortLogic(string kind, int firstPatient, int secondPatient, const PatientsList& patients) {
    bool equalDays = patients[secondPatient].appointDay == patients[firstPatient].appointDay ;
    bool disorderedNames = sortedStrings(patients[secondPatient].name, patients[firstPatient].name) ;

    if (kind == "day"){
        bool disorderedDays = patients[secondPatient].appointDay < patients[firstPatient].appointDay ;

        return disorderedDays ;
    }
    
    if (kind == "time"){
        bool disorderedHours = patients[secondPatient].appointTime < patients[firstPatient].appointTime ;

        return equalDays && disorderedHours  ;
    }

    if (kind == "name") {
        bool equalHours = patients[secondPatient].appointTime == patients[firstPatient].appointTime ;

        return equalDays && equalHours && disorderedNames ;
    }

    if (kind == "just name")
        return disorderedNames ;
    
    return false ;
}

void patientsSorter(PatientsList& patients , string kind){
    Patient sortKeeper ;

    for (int i = 0; i < patients.size(); i++)
        for (int j = i+1 ; j < patients.size(); j++)
            if (patientsSortLogic(kind, i, j, patients)) {
                sortKeeper = patients[i] ;
                patients[i] = patients[j] ;
                patients[j] = sortKeeper ;
            }
}

vector<string> fileExtractor(string address) {
    fstream File;
    File.open(address, ios::in);
    
    vector<string> rows ;
    string rowKeeper ;

    getline(File, rowKeeper);
    while ( getline(File, rowKeeper) )
        rows.push_back(rowKeeper) ;

    File.close();

    return rows ;
}

SpecialtiesList organizeDiseases(vector<string> rows) {
    SpecialtiesList specialties ;

    for (auto row : rows) {
        Specialty inputSpecialty ;

        string diseaseKeeper ;
        stringstream rowStream(row);

        getline(rowStream, inputSpecialty.name, ',') ;

        while (getline(rowStream, diseaseKeeper, '$'))
            inputSpecialty.diseases.push_back(diseaseKeeper) ;

        specialties.push_back(inputSpecialty) ;
    }

    return specialties ;
}

string searchSpecialty(const SpecialtiesList& specialties, string disease) {
    for (auto specialty : specialties)
        if (find(specialty.diseases.begin(), specialty.diseases.end(), disease) != specialty.diseases.end())
            return specialty.name ;
    
    return "not found" ;
}

PatientsList organizePatients(vector<string> rows) {
    SpecialtiesList specialties = organizeDiseases(fileExtractor("diseases.csv")) ;
    PatientsList patients ;

    for (auto row : rows) {
        Patient inputPatient ;

        string timeKeeper ;
        string medicalIssue ;
        stringstream rowStream(row); 
        
        getline(rowStream, inputPatient.name, ',');
        
        getline(rowStream, medicalIssue, ',');
        inputPatient.specialty = searchSpecialty(specialties, medicalIssue);

        getline(rowStream, timeKeeper);
        stringstream timeStream(timeKeeper);

        getline(timeStream, timeKeeper, '-');
        inputPatient.appointDay = convertDayToNum(timeKeeper);

        getline(timeStream, timeKeeper) ;
        inputPatient.appointTime = stoi(timeKeeper);

        patients.push_back(inputPatient);
    }

    return patients ;
} 

void sortAvailableDays(DaysList& availableDays) {
    WorkDay sortKeeper ;

    for (int i = 0; i < availableDays.size() ; i++)
        for (int j = i+1 ; j < availableDays.size(); j++)
            if (availableDays[j].day <= availableDays[i].day) {
                sortKeeper = availableDays[i] ;
                availableDays[i] = availableDays[j] ;
                availableDays[j] = sortKeeper ;
            }
}

DaysList organizeAvailableDays(string disorganizedInfo) {
    DaysList availableDays ;
    string tempKeeper ;
    stringstream timesStream(disorganizedInfo);

    while (getline(timesStream, tempKeeper, '$')) {
        WorkDay inputDay ;
        stringstream timeStream(tempKeeper);

        getline(timeStream, tempKeeper, '-');
        inputDay.day = convertDayToNum(tempKeeper);

        getline(timeStream, tempKeeper, '-');
        inputDay.startHour = stoi(tempKeeper) * 60 ;

        getline(timeStream, tempKeeper);
        inputDay.endHour = stoi(tempKeeper) * 60;

        availableDays.push_back(inputDay) ;
    }

    sortAvailableDays(availableDays);

    return availableDays ;
}

WorkDay nextFreeAppoint(WorkDay& currentDay, const DaysList& availableDays) {
    int dayIndex ;

    for (dayIndex = 0; dayIndex < (availableDays.size() - 1) ; dayIndex++)
        if (availableDays[dayIndex].day == currentDay.day) 
            return availableDays[dayIndex+1] ;

    return availableDays[dayIndex] ;
}

void setFirstFreeAppoint(Doctor& doctor, WorkDay& currentFreeAppoint) {
    int freeTimeDuration = currentFreeAppoint.endHour - currentFreeAppoint.startHour ;

    if (freeTimeDuration < doctor.visitDuration) {
        WorkDay firstFreeAppoint = nextFreeAppoint(currentFreeAppoint, doctor.availableDays);
        doctor.firstFreeDay = firstFreeAppoint.day ;
        doctor.firstFreeTime = firstFreeAppoint.startHour ;
    } else {
        doctor.firstFreeDay = currentFreeAppoint.day ;
        doctor.firstFreeTime = currentFreeAppoint.startHour ;
    }    
}

DoctorsList organizeDoctors(vector<string> rows) {
    DoctorsList doctors ;

    for (auto row : rows) {
        Doctor inputDoctor ;
        stringstream rowStream(row); 
        string tempKeeper ;
        
        getline(rowStream, inputDoctor.name, ',');
        getline(rowStream, inputDoctor.specialty, ',');

        getline(rowStream, tempKeeper, ',');
        inputDoctor.visitFee = stoi(tempKeeper) ;

        getline(rowStream, tempKeeper, ',');
        inputDoctor.visitDuration = stoi(tempKeeper) ;

        getline(rowStream, tempKeeper, ',');
        inputDoctor.waitTimeAvarage = stoi(tempKeeper) ;

        getline(rowStream, tempKeeper, '\n');
        inputDoctor.availableDays = organizeAvailableDays(tempKeeper) ;

        setFirstFreeAppoint(inputDoctor, inputDoctor.availableDays[0]);

        doctors.push_back(inputDoctor);
    }

    return doctors ;
}

string convertNumToDay(int dayNumber){
    vector<string> days = {"Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"} ;
    return days[dayNumber] ;
}

DepartmentsList groupingDoctors(DoctorsList doctors){
    DepartmentsList departments ;

    for (int i = 0; i < doctors.size(); i++) {
        bool isGrouped = false ;

        for (int j = 0; j < departments.size(); j++)
            if (departments[j].specialty == doctors[i].specialty) {
                departments[j].doctors.push_back(doctors[i]) ;
                isGrouped = true ;
                break;
            }

        if (!isGrouped) {
            Department department ;
            department.specialty = doctors[i].specialty;
            department.doctors.push_back(doctors[i]) ;
            departments.push_back(department);
        }
    }

    return departments ;   
}

bool doctorsSortLogic(string kind, int firstPatient, int secondPatient,const Department& department){
    bool equalDay = (department.doctors[secondPatient].firstFreeDay == department.doctors[firstPatient].firstFreeDay) ;
    bool equalHour = (department.doctors[secondPatient].firstFreeTime == department.doctors[firstPatient].firstFreeTime) ;
    bool equalFee = (department.doctors[secondPatient].visitFee == department.doctors[firstPatient].visitFee) ;

    if (kind == "day") {
        bool disorderedDay = department.doctors[secondPatient].firstFreeDay < department.doctors[firstPatient].firstFreeDay;

        return disorderedDay ;
    }

    if (kind == "time") {
        bool disorderedHour = department.doctors[secondPatient].firstFreeTime < department.doctors[firstPatient].firstFreeTime ;

        return equalDay && disorderedHour ;
    }

    if (kind == "fee") {
        bool disorderedFee = department.doctors[secondPatient].visitFee < department.doctors[firstPatient].visitFee ;

        return equalDay && equalHour && disorderedFee ;
    }

    if (kind == "waitTime") {
        bool disorderedWaitTime = department.doctors[secondPatient].waitTimeAvarage < department.doctors[firstPatient].waitTimeAvarage ;

        return equalDay && equalHour && equalFee && disorderedWaitTime ;   
    }

    if (kind == "name") {
        bool equalWaitTime = (department.doctors[secondPatient].waitTimeAvarage == department.doctors[firstPatient].waitTimeAvarage) ;
        bool disorderedName = sortedStrings(department.doctors[secondPatient].name, department.doctors[firstPatient].name) ;

        return equalDay && equalHour && equalFee && equalWaitTime && disorderedName ;
    }
    
    return false ;
}

void doctorsSorter(Department& department, string kind) {
    Doctor keeper ;

    for (int i = 0; i < department.doctors.size(); i++)
        for (int j = i+1; j < department.doctors.size(); j++)
            if (doctorsSortLogic(kind, i, j, department)) {
                keeper = department.doctors[i] ;
                department.doctors[i] = department.doctors[j] ;
                department.doctors[j] = keeper ;
            }
}

void setPetientAppointment(Patient& patient, Doctor& doctor, WorkDay& workDay){
    patient.doctor = doctor.name ;
    patient.visitDay = workDay.day ;
    patient.visitNumber = workDay.visitNumber ;
    patient.visitTime = workDay.startHour ;
    patient.visitCharge = doctor.visitFee ;
}

void changeDoctorStatus(Doctor& doctor, WorkDay& workDay, Department& department) {
    workDay.startHour += doctor.visitDuration ;
    workDay.visitNumber += 1 ;
    setFirstFreeAppoint(doctor, workDay) ;
    sortDoctors(department);
}

bool findingFreeDay(Doctor& doctor, Patient& patient, Department& department) {
    for (auto& workDay : doctor.availableDays) {
        int freetime = (workDay.endHour - workDay.startHour) ;

        if (doctor.visitDuration <= freetime ) {
            setPetientAppointment(patient, doctor, workDay);
            changeDoctorStatus(doctor, workDay, department);
            return true ;
        }
    }

    return false ;
}

void findingDoctor(Department& department, Patient& patient) {
    for (auto& doctor : department.doctors)
        if (findingFreeDay(doctor, patient, department))
            break;                    
}

void appointing(Patient& patient, DepartmentsList& departments) {
    for (auto& department : departments)
        if (department.specialty == patient.specialty) {
            findingDoctor(department, patient);
            break;
        }
}

void checkingForZeroBehind(int number) {
    if (number < 10)
        cout << "0" << number ;
    else
        cout << number ;
}

void timeFormatPrinter(int time){
    int hour = time/60 ;
    int min = time%60 ;

    checkingForZeroBehind(hour);
    cout << ":" ;
    checkingForZeroBehind(min) ;
    cout << endl ;
}

void printingFormat(const Patient& patient) {
    if (patient.visitDay == NotFound) {
        cout << "Name: " << patient.name << endl ;
        cout << "No free time" << endl ;
    } else {
        cout << "Name: " << patient.name << endl; 
        cout << "Doctor: " << patient.doctor << endl ;
        cout << "Visit: " << convertNumToDay(patient.visitDay) << " " << patient.visitNumber << " " ;
        timeFormatPrinter(patient.visitTime) ;
        cout << "Charge: " << patient.visitCharge << endl ;
    }  
}

void printer(PatientsList& patients) {
    int patientNum ;

    patientsSorter(patients, "just name");

    for (patientNum = 0; patientNum < (patients.size()-1); patientNum++) {
        printingFormat(patients[patientNum]);
        cout << "----------" << endl ;
    }

    printingFormat(patients[patientNum]) ;
}

void sortPatients(PatientsList& patients) {
    patientsSorter(patients, "day");
    patientsSorter(patients, "time");
    patientsSorter(patients, "name");
}

void sortDoctors(Department& department) {
    doctorsSorter(department, "day");
    doctorsSorter(department, "time");
    doctorsSorter(department, "fee");
    doctorsSorter(department, "waitTime");
    doctorsSorter(department, "name");
}

int main() {
    PatientsList patients = organizePatients( fileExtractor("patients.csv") ) ;
    DepartmentsList departments = groupingDoctors( organizeDoctors( fileExtractor("doctors.csv") ) );

    sortPatients(patients) ;

    for (auto& department : departments)
        sortDoctors(department) ;

    for (auto& patient : patients)
        appointing(patient, departments);

    printer(patients);

    return 0;
}