package pt.isel.shipconquest.repo

interface Transaction {
    val gameRepo: GameRepository
    val shipRepo: ShipRepository
    val islandRepo: IslandRepository
    val lobbyRepo: LobbyRepository
    val statsRepo: StatisticsRepository
    val eventRepo: EventRepository
    val userRepo: UserRepository
    val patchNotesRepo: PatchNotesRepository

    // reverse changes made by the current transaction
    fun rollback()
}