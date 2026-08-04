-- ECZChat clásico B42.20
-- Desactivado: este módulo ejecutaba pcall(require, ...) cada tick hasta 900 veces
-- para clases antiguas de elaboración, forrajeo y administración.
ECZUIThemeHooks = ECZUIThemeHooks or { installed = true, disabled = true }
return ECZUIThemeHooks
