# **Zupan Take-Home Exercise**

This repository contains a take-home exercise for Zupan. The primary goal of this application is to handle speech recognition and translate spoken words into commands.

## **Features**

- **Extensibility**: Beyond the requested features, this app is designed to be highly extensible.

## **Project Structure**

- **Domain Folder**: Handles everything related to the domain, including the app's main logic and the command entity.
- **Views Folder**: Contains all files related to both views and their corresponding view-models (Language View and Speech-Commands Views).
- **Handlers Folder**: Includes all files that handle commands and the protocol to which all handlers must conform.
- **Services Folder**: Manages all services and auxiliary functions/classes related to the speech recognition service.

## **Bonus Features**

The exercise mentioned that including certain features would be a plus. These are described below:

### **Secondary Language Support**

The current codebase supports six languages:

- English (United States) - **`en_US`**
- Spanish (Spain) - **`es_ES`**
- French (France) - **`fr_FR`**
- German (Germany) - **`de_DE`**
- Italian (Italy) - **`it_IT`**
- Portuguese (Brazil) - **`pt_BR`**

Adding new languages is straightforward. Simply add the desired language to the list in **`LanguageSelectionViewModel.swift`** and update the **`CommandMappings.json`** with the new language and its corresponding commands.

### **Adding New Commands**

Adding new commands is also easy. To do so:

1. Add the new command to all languages in the **`CommandMappings.json`** file.
2. Create a new class in the Handlers folder that conforms to the **`CommandHandler`** protocol and implement the command's functionality.
3. Add an instance of the new handler to the **`commandHandlers`** array in **`CommandsService.swift`**.

For type safety, there is also an enum that lists all the commands.

### **Production-Ready Features**

The code is designed to be both shippable and extensible. Commands and configurations are decoupled, making it easier to maintain and extend.
