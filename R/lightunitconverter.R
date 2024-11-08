# Load the units package
library(units)
library(constants)

#' @importFrom constants syms
#' @importFrom units set_units
# Load the units package
convert_to_photons <- function(power_density, wavelength) {
  # Check if inputs have compatible units
  if (!inherits(try(set_units(power_density, "mW/mm^2"), silent = TRUE), "units")) {
    stop("Input 'power_density' must be convertible to 'mW/mm^2'")
  }
  if (!inherits(try(set_units(wavelength, "nm"), silent = TRUE), "units")) {
    stop("Input 'wavelength' must be convertible to 'nm'")
  }

  # Convert power_density to W/cm^2
  power_density <- set_units(power_density, "W/cm^2")

  # Constants with units
  h <- set_units(syms$h, "J/Hz")  # Planck's constant #lookup("h",cols="symbol")[lookup("h",cols="symbol")$symbol=="h","unit"]
  c <- set_units(syms$c0, "m/s")        # Speed of light

  # Energy per photon (no need to convert wavelength to meters manually)
  energy_per_photon <- h * c / wavelength

  # Photon flux in photons/cm^2/s
  photon_flux <- power_density / energy_per_photon
  photon_flux <- set_units(photon_flux, "1/cm^2/s")

  return(photon_flux)
}

# Example usage:
power_density <- set_units(0.1, "mW/mm^2")  # Power density in mW/mm^2
wavelength <- set_units(610, "nm")        # Wavelength in nm

convert_to_photons(power_density, wavelength)
