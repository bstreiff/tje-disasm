/* Game revision: 0 for REV00, 2 for REV02 */
#if !defined(GAME_REVISION)
#define GAME_REVISION 2
#elif !(GAME_REVISION == 0) && !(GAME_REVISION == 2)
#error unknown game revision
#endif

/* Game build
   BUILD_M2_MENU_FIX: build ToeJamEarl_2012_06_21_MENU_FIX.GEN from
                      the Sega Vintage Collection for the Xbox 360.
   BUILD_M2_SAWA:     build ToeJamEarl0618_sawa.GEN from the Sega
                      Vintage Collection for the Xbox 360.
*/
#if !defined(BUILD_M2_MENU_FIX)
#define BUILD_M2_MENU_FIX 0
#endif
#if !defined(BUILD_M2_SAWA)
#define BUILD_M2_SAWA 0
#endif
#if ((BUILD_M2_MENU_FIX == 1) && (BUILD_M2_SAWA == 1))
#error multiple M2 build options cannot be specified
#endif
#if ((BUILD_M2_MENU_FIX == 1) || (BUILD_M2_SAWA == 1)) && (GAME_REVISION != 2)
#error M2 build options require revision 02
#endif
