import Foundation

enum CoreDataErrors: LocalizedError {
    case DeletingEroor
    case DataError
    case SavingError
    case ApendError
    case LoadError
    case none

    var localizedDescription: String {
        switch self {
        case .DataError:
            return "Wrong data"
        case .DeletingEroor:
            return "Data has not been deleted"
        case .none:
            return "Without errors"
        case .SavingError:
            return "Data has not been saved"
        case .ApendError:
            return "Data has not been append"
        case .LoadError:
            return "Load data error"
        }
    }
}
