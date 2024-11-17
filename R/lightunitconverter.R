# Load the units package
library(units)
library(constants)

#' @importFrom constants syms
#' @importFrom units set_units
power_density_to_photon_flux <- function(power_density, wavelength) {
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

#' @importFrom units set_units
ganzfeld_luminance_to_pupil_photon_flux <- function(scot_luminance) {
  # https://www.sciencedirect.com/science/article/pii/S0042698904004468?via%3Dihub#sec1
  if (!inherits(try(set_units(scot_luminance, "cd/m^2"), silent = TRUE)
                , "units")) {
    stop("Input 'scot_luminance' must be convertible to 'cd/m^2'")
  }

  fact <-
    set_units(1.5 * 10 ^ 15, "1/(s*lm)")# the factor 1.5 × 1015 converts scotopic lumens to photon flux, and has the units (photons s−1 lumen−1).

  pi*fact*scot_luminance
}


#' # Example usage:
power_density <- set_units(0.1, "mW/mm^2")  # Power density in mW/mm^2
wavelength <- set_units(610, "nm")        # Wavelength in nm
convert_to_photons(power_density, wavelength)

flash_energy=set_units(3, "cd*s/m^2")
scot_luminance<-flash_energy/set_units(0.04,"s")#set_units(30, "cd/m^2")
out<-ganzfeld_luminance_to_pupil_photon_flux(scot_luminance)
format(set_units(out, "1/cm^2/s"), scientific = TRUE)
