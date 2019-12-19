//___FILEHEADER___

protocol ___FILEBASENAMEASIDENTIFIER___ViewModelConvertible: ViewModelConvertible {
    func get<#Sth#>() -> <#Type#>?
}

struct ___FILEBASENAMEASIDENTIFIER___ViewModel: ___FILEBASENAMEASIDENTIFIER___ViewModelConvertible {

    required init() {
    }

    func bind<T>(_ model: T) {
        guard let <#name#> = model as? <#Type#> else {
            return
        }

        <#code#>
    }

    func get<#Sth#>() -> <#Type#>? {
        <#code#>
    }
}

extension ___FILEBASENAMEASIDENTIFIER___ViewModel {
    private func set<#Sth#>(with type: <#Type#>) {
        <#code#>
    }
}
