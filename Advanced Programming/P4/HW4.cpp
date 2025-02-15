#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <iomanip>
using namespace std;

const int FAIL = -1;
const int EXEPTION_FAIL = -2;
const int PASS = 0;

class Bank
{
public:
    Bank(int id, int profit, double minInvestment);

    bool supportMinInvest(double cash, int years) { return ((minInvestment * years) <= cash); }
    bool isMyId(int InputId) { return (id == InputId); }
    int shAccountIdGenrator();

    int getProfit() { return profit; }

private:
    int id;
    int profit;
    int shAccountsCount;
    double minInvestment;
};

Bank ::Bank(int inputId, int inputProfit, double inputMinInvestment)
{
    id = inputId;
    profit = inputProfit;
    minInvestment = inputMinInvestment;
    shAccountsCount = 0;
}

int Bank ::shAccountIdGenrator()
{
    shAccountsCount += 1;
    return shAccountsCount;
}
class ShortTerm
{
public:
    ShortTerm(int InputId, double investment, Bank *inputProvider);

    bool isMyId(int inputId) { return (id == inputId); }
    bool isMyProvider(Bank *bank) { return (bank == provider); }
    double getCharge() { return charge; }

    void addMoney(double value) { charge += value; }
    void payInterest(int month);

private:
    int id;
    double firstInvestment;
    double charge;
    Bank *provider;
};

ShortTerm ::ShortTerm(int InputId, double investment, Bank *inputProvider)
{
    id = InputId;
    firstInvestment = investment;
    charge = investment;
    provider = inputProvider;
}

void ShortTerm ::payInterest(int month)
{
    charge += month * firstInvestment * (provider->getProfit()) * 0.01;
}

class LongTerm
{
public:
    LongTerm(int inputYears, double investment, ShortTerm *shAccount, Bank *inputProvider);
    void payInterest(int month);
    bool isMyProvider(Bank *bank) { return (bank == provider); };
    double getCharge() { return charge; }

private:
    int years;
    double charge;
    ShortTerm *connectedDeposit;
    Bank *provider;
};

LongTerm ::LongTerm(int inputYears, double investment, ShortTerm *shAccount, Bank *inputProvider)
{
    years = inputYears;
    charge = investment;
    connectedDeposit = shAccount;
    provider = inputProvider;
}

void LongTerm ::payInterest(int month)
{
    connectedDeposit->addMoney(month * charge * (provider->getProfit()) * years * 0.01);
}

class GharzolHassaneh
{
public:
    GharzolHassaneh(Bank *InputProvider, double investment);
    bool isMyProvider(Bank *bank) { return (bank == provider); }
    double getCharge() { return charge; }

private:
    double charge;
    Bank *provider;
};

GharzolHassaneh ::GharzolHassaneh(Bank *InputProvider, double investment)
{
    charge = investment;
    provider = InputProvider;
}

class User
{
public:
    User(int inputId, double charge);

    int create_short_term_deposit(Bank *provider, double initialInvestment);
    void create_gharzolhasane_deposit(Bank *provider, double initialInvestment);
    int create_long_term_deposit(Bank *provider, int shortTermId, int years, double initialInvestment);
    double inventory_report(Bank *bank, int shDepositId);
    double calcMoney(Bank *bank, bool allbanks);

    void payInterests(int month);
    bool isMyId(int inputId) { return (id == inputId); }

private:
    ShortTerm *shAccountFinder(int shortTermId, Bank *bank);
    int id;
    double wallet;
    vector<ShortTerm *> shortTermAccounts;
    vector<LongTerm *> longTermAccounts;
    vector<GharzolHassaneh *> ghAccounts;
};

User ::User(int inputId, double charge)
{
    id = inputId;
    wallet = charge;
}

ShortTerm *User ::shAccountFinder(int shortTermId, Bank *bank)
{
    for (auto &account : shortTermAccounts)
        if (account->isMyId(shortTermId) && account->isMyProvider(bank))
            return account;

    return NULL;
}

double User ::inventory_report(Bank *bank, int shDepositId)
{
    ShortTerm *account = shAccountFinder(shDepositId, bank);

    if (account == NULL)
        return FAIL;

    return (account->getCharge());
}

double User ::calcMoney(Bank *bank, bool allbanks)
{
    double charge = 0;

    for (auto &shAccount : shortTermAccounts)
        if ((allbanks) ? true : shAccount->isMyProvider(bank))
            charge += shAccount->getCharge();

    for (auto &loAccount : longTermAccounts)
        if ((allbanks) ? true : loAccount->isMyProvider(bank))
            charge += loAccount->getCharge();

    for (auto &ghAccount : ghAccounts)
        if ((allbanks) ? true : ghAccount->isMyProvider(bank))
            charge += ghAccount->getCharge();

    return charge;
}

int User ::create_short_term_deposit(Bank *provider, double initialInvestment)
{
    if (!provider->supportMinInvest(initialInvestment, 1) || wallet < initialInvestment)
        return FAIL;

    int accountId = provider->shAccountIdGenrator();
    wallet -= initialInvestment;
    shortTermAccounts.push_back(new ShortTerm(accountId, initialInvestment, provider));
    return accountId;
}

int User ::create_long_term_deposit(Bank *provider, int shortTermId, int years, double initialInvestment)
{
    if (!provider->supportMinInvest(initialInvestment, years) || wallet < initialInvestment)
        return FAIL;

    ShortTerm *attachedShAccount = shAccountFinder(shortTermId, provider);
    if (attachedShAccount == NULL)
        return EXEPTION_FAIL;

    wallet -= initialInvestment;
    longTermAccounts.push_back(new LongTerm(years, initialInvestment, attachedShAccount, provider));
    return PASS;
}

void User ::create_gharzolhasane_deposit(Bank *provider, double initialInvestment)
{
    if (wallet < initialInvestment)
        return;

    wallet -= initialInvestment;
    ghAccounts.push_back(new GharzolHassaneh(provider, initialInvestment));
}

void User ::payInterests(int month)
{
    for (auto &shAccount : shortTermAccounts)
        shAccount->payInterest(month);

    for (auto &loAccount : longTermAccounts)
        loAccount->payInterest(month);
}

class DigitalBanking
{
public:
    DigitalBanking(vector<Bank *> inputBanks, vector<User *> inputUsers);

    int create_short_term_deposit(int userId, int bankId, double initialInvestment);
    void create_gharzolhasane_deposit(int userId, int bankId, double initialInvestment);
    int create_long_term_deposit(int userId, int bankId, int shortTermId, int years, double initialInvestment);

    void pass_time(int month);

    double inventory_report(int userId, int bankId, int shDepositId);
    double calc_money_in_bank(int userId, int bankId);
    double calc_all_money(int userId);

private:
    Bank *findBankById(int id);
    User *findUserById(int id);
    vector<Bank *> banks;
    vector<User *> users;
};

DigitalBanking ::DigitalBanking(vector<Bank *> inputBanks, vector<User *> inputUsers)
{
    banks = inputBanks;
    users = inputUsers;
}

Bank *DigitalBanking ::findBankById(int id)
{
    for (auto &bank : banks)
        if (bank->isMyId(id))
            return bank;

    return NULL;
}

User *DigitalBanking ::findUserById(int id)
{
    for (auto &user : users)
        if (user->isMyId(id))
            return user;

    return NULL;
}

int DigitalBanking ::create_short_term_deposit(int userId, int bankId, double initialInvestment)
{
    return findUserById(userId)->create_short_term_deposit(findBankById(bankId), initialInvestment);
}

int DigitalBanking ::create_long_term_deposit(int userId, int bankId, int shortTermId, int years, double initialInvestment)
{
    return findUserById(userId)->create_long_term_deposit(findBankById(bankId), shortTermId, years, initialInvestment);
}

void DigitalBanking ::create_gharzolhasane_deposit(int userId, int bankId, double initialInvestment)
{
    findUserById(userId)->create_gharzolhasane_deposit(findBankById(bankId), initialInvestment);
}

void DigitalBanking ::pass_time(int month)
{
    for (auto &user : users)
        user->payInterests(month);
}

double DigitalBanking ::inventory_report(int userId, int bankId, int shDepositId)
{
    return findUserById(userId)->inventory_report(findBankById(bankId), shDepositId);
}

double DigitalBanking ::calc_money_in_bank(int userId, int bankId)
{
    return findUserById(userId)->calcMoney(findBankById(bankId), false);
};

double DigitalBanking ::calc_all_money(int userId)
{
    return findUserById(userId)->calcMoney(NULL, true);
};

class Interface
{
public:
    Interface(vector<string> inputMessages) { messages = inputMessages; }
    vector<Bank*> createInputBanks();
    vector<User*> createInputUsers();
    void commandExecuter(string command, DigitalBanking &digitalBankSystem);
    void addressExtractor(int argc, char *argv[], vector<string> commandTags);

private:
    vector<string> fileExtractor(string address);
    vector<string> dataSeparator(string dataLine, int dataCount, char separator);
    vector<string> commandPropReader(int propCount) ;
    void longTermCreationResultPrinter(int result) ;
    void inventoryReportResultPrinter(double result) ;
    vector<string> messages;
    vector<string> addresses;
};

void Interface ::addressExtractor(int argc, char *argv[], vector<string> commandTags)
{
    vector<string> inputAddresses(commandTags.size());
    for (int i = 1; i < argc; i += 2)
        for (int j = 0; j < commandTags.size(); j++)
            if (argv[i] == commandTags[j])
            {
                inputAddresses[j] = argv[i + 1];
                break;
            }

    addresses = inputAddresses;
}

vector<string> Interface ::fileExtractor(string address)
{
    fstream File;
    File.open(address, ios::in);

    vector<string> rows;
    string rowKeeper;

    getline(File, rowKeeper);
    while (getline(File, rowKeeper))
        rows.push_back(rowKeeper);

    File.close();

    return rows;
}

vector<string> Interface :: dataSeparator(string dataLine, int dataCount, char separator)
{
    stringstream rowStream(dataLine);
    vector<string> tempKeeper(dataCount);

    for (int i = 0; i < dataCount; i++)
        getline(rowStream, tempKeeper[i], separator);

    return tempKeeper;
}

vector<string> Interface :: commandPropReader(int propCount)
{
    vector<string> tempKeeper(propCount);
    for (int i = 0; i < propCount; i++)
        cin >> tempKeeper[i];

    return tempKeeper;
}

vector<Bank *> Interface ::createInputBanks()
{
    vector<Bank *> banks;
    vector<string> rows = fileExtractor(addresses[0]);

    for (auto row : rows)
    {
        vector<string> tempKeeper = dataSeparator(row, 3, ',');
        banks.push_back(new Bank(stoi(tempKeeper[0]), stoi(tempKeeper[1]), stod(tempKeeper[2])));
    }

    return banks;
}

vector<User *> Interface ::createInputUsers()
{
    vector<User *> users;
    vector<string> rows = fileExtractor(addresses[1]);

    for (auto row : rows)
    {
        vector<string> tempKeeper = dataSeparator(row, 2, ',');
        users.push_back(new User(stoi(tempKeeper[0]), stod(tempKeeper[1])));
    }

    return users;
}

void Interface :: longTermCreationResultPrinter(int result)
{
    if (result == FAIL)
        cout << messages[1] << endl;
    else if (result == EXEPTION_FAIL)
        cout << messages[2] << endl;
    else
        cout << messages[0] << endl;
}

void Interface :: inventoryReportResultPrinter(double result) {
    if (result == FAIL)
            cout << messages[2] << endl;
        else
            cout << fixed << setprecision(2) << result << endl;
}

void Interface ::commandExecuter(string command, DigitalBanking &digitalBankSystem)
{
    if (command == "create_short_term_deposit")
    {
        vector<string> property = commandPropReader(3);
        int result = digitalBankSystem.create_short_term_deposit(stoi(property[0]), stoi(property[1]), stod(property[2]));
        cout << ((result == FAIL) ? messages[1] : to_string(result)) << endl;
    }
    else if (command == "create_long_term_deposit")
    {
        vector<string> property = commandPropReader(5);
        int result = digitalBankSystem.create_long_term_deposit(stoi(property[0]), stoi(property[1]), stoi(property[2]), stoi(property[3]), stod(property[4]));
        longTermCreationResultPrinter(result);
    }
    else if (command == "create_gharzolhasane_deposit")
    {
        vector<string> property = commandPropReader(3);
        digitalBankSystem.create_gharzolhasane_deposit(stoi(property[0]), stoi(property[1]), stod(property[2]));
        cout << messages[0] << endl;
    }
    else if (command == "pass_time")
    {
        vector<string> property = commandPropReader(1);
        digitalBankSystem.pass_time(stoi(property[0]));
        cout << messages[0] << endl;
    }
    else if (command == "inventory_report")
    {
        vector<string> property = commandPropReader(3);
        double result = digitalBankSystem.inventory_report(stoi(property[0]), stoi(property[1]), stoi(property[2]));
        inventoryReportResultPrinter(result);
    }
    else if (command == "calc_money_in_bank")
    {
        vector<string> property = commandPropReader(2);
        double result = digitalBankSystem.calc_money_in_bank(stoi(property[0]), stoi(property[1]));
        cout << fixed << setprecision(2) << result << endl;
    }
    else if (command == "calc_all_money")
    {
        vector<string> property = commandPropReader(1);
        double result = digitalBankSystem.calc_all_money(stoi(property[0]));
        cout << fixed << setprecision(2) << result << endl;
    }
}

int main(int argc, char *argv[])
{
    Interface terminal({"OK", "Not enough money", "Invalid short-term deposit"});
    terminal.addressExtractor(argc, argv, {"-b", "-u"});

    DigitalBanking digitalBankSystem(terminal.createInputBanks(), terminal.createInputUsers());

    string command;
    while (cin >> command)
        terminal.commandExecuter(command, digitalBankSystem);

    return 0;
}