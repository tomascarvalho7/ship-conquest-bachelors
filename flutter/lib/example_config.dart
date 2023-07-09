/// Instead of using a .env file, we are storing the private information in this file, out of the version control
/// system's sight.
///
/// In Flutter, to use a .env we need to import a package, but the .env file is still in the
/// compiled files and easily accessible, this means that its not private to attackers, only to the VCS.
///
/// Because of this, it makes no sense to use another package when this approach has the same effect.

const clientId = ""; // Google client id
const baseUri = ""; // Server URI to make requests