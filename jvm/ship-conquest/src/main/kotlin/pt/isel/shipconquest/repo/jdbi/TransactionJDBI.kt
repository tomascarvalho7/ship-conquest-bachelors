package pt.isel.shipconquest.repo.jdbi

import com.example.shipconquest.repo.*
import org.jdbi.v3.core.Handle

class TransactionJDBI(private val handle: Handle): Transaction {
    override val gameRepo: GameRepository by lazy { GameRepositoryJDBI(handle = handle) }
    override val shipRepo: ShipRepository by lazy { ShipRepositoryJDBI(handle = handle) }
    override val islandRepo: IslandRepository by lazy { IslandRepositoryJDBI(handle = handle) }
    override val lobbyRepo: LobbyRepository by lazy { LobbyRepositoryJDBI(handle = handle)}
    override val statsRepo: StatisticsRepository by lazy { StatisticsRepositoryJDBI(handle = handle)}
    override val eventRepo: EventRepository by lazy { EventRepositoryJDBI(handle = handle) }
    override val userRepo: UserRepository by lazy { UserRepositoryJDBI(handle = handle)}
    override val patchNotesRepo: PatchNotesRepository by lazy { PatchNotesRepositoryJDBI(handle = handle) }

    override fun rollback() {
        handle.rollback()
    }
}