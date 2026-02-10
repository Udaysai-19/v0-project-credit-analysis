import { createClient } from "@/lib/supabase/server"
import { AchievementsView } from "@/components/dashboard/achievements-view"

export default async function AchievementsPage() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) return null

  const { data: achievements } = await supabase
    .from("achievements")
    .select("*")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false })

  const { data: progressRecords } = await supabase
    .from("progress_records")
    .select("*")
    .eq("user_id", user.id)

  return (
    <AchievementsView
      userId={user.id}
      achievements={achievements || []}
      totalWorkouts={progressRecords?.length || 0}
    />
  )
}
