-- CreateEnum
CREATE TYPE "UserRoles" AS ENUM ('MEMBER', 'BRONZE', 'SILVER', 'GOLD', 'DIAMOND', 'MODERATOR', 'ADMIN', 'MASTER');

-- CreateEnum
CREATE TYPE "ScanMemberType" AS ENUM ('OWNER', 'ADMIN', 'MEMBER');

-- CreateEnum
CREATE TYPE "ScanInviteStatus" AS ENUM ('PENDING', 'REJECTED', 'ACCEPTED');

-- CreateEnum
CREATE TYPE "VoteTypes" AS ENUM ('HEART', 'LIKE', 'DISLIKE');

-- CreateTable
CREATE TABLE "Register" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "hash" TEXT NOT NULL,

    CONSTRAINT "Register_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "display_name" TEXT,
    "gradient" TEXT[],
    "description" TEXT NOT NULL DEFAULT 'Eu **<3** Pão de Mel.',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "logged_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "muted_until" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "premium_until" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "banned" BOOLEAN NOT NULL DEFAULT false,
    "roles" "UserRoles"[],

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserStats" (
    "id" SERIAL NOT NULL,
    "views" INTEGER NOT NULL DEFAULT 0,
    "coins" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "UserStats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserLists" (
    "id" SERIAL NOT NULL,

    CONSTRAINT "UserLists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Discord" (
    "id" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "username" TEXT NOT NULL,
    "token" TEXT,
    "refresh" TEXT,
    "sync_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Discord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Anilist" (
    "id" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "username" TEXT NOT NULL,
    "token" TEXT,
    "refresh" TEXT,
    "sync_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Anilist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MyAnimeList" (
    "id" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "username" TEXT NOT NULL,
    "token" TEXT,
    "refresh" TEXT,
    "sync_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MyAnimeList_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SuperFans" (
    "id" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "username" TEXT NOT NULL,
    "token" TEXT,
    "refresh" TEXT,
    "sync_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SuperFans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scan" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "discord" TEXT,
    "website" TEXT,
    "donate" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_upload" TIMESTAMP(3),

    CONSTRAINT "Scan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScanUser" (
    "id" SERIAL NOT NULL,

    CONSTRAINT "ScanUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScanMembers" (
    "id" SERIAL NOT NULL,
    "scan_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "role" "ScanMemberType" NOT NULL DEFAULT 'MEMBER',
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "display_name" TEXT,
    "details" TEXT,

    CONSTRAINT "ScanMembers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScanInvites" (
    "id" SERIAL NOT NULL,
    "scan_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "admin_id" INTEGER NOT NULL,
    "invited_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "ScanInviteStatus" NOT NULL DEFAULT 'PENDING',

    CONSTRAINT "ScanInvites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScanVotes" (
    "id" SERIAL NOT NULL,
    "scan_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "type" SMALLINT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ScanVotes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScanIcon" (
    "id" SERIAL NOT NULL,
    "b2" TEXT,
    "uri" TEXT,
    "size" INTEGER NOT NULL DEFAULT 0,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ScanIcon_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScanBanner" (
    "id" SERIAL NOT NULL,
    "b2" TEXT,
    "uri" TEXT,
    "size" INTEGER NOT NULL DEFAULT 0,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ScanBanner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Manga" (
    "id" SERIAL NOT NULL,
    "slug" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "title_english" TEXT,
    "title_original" TEXT,
    "title_alternatives" TEXT[],
    "searcher" VARCHAR(12000),
    "description" TEXT NOT NULL DEFAULT 'Descrição Indisponível',
    "anilist" TEXT,
    "myanimelist" TEXT,
    "superfans" TEXT,
    "scrapper" TEXT,
    "artists" TEXT[],
    "authors" TEXT[],
    "visible" BOOLEAN NOT NULL DEFAULT true,
    "nsfw" BOOLEAN NOT NULL DEFAULT false,
    "hentai" BOOLEAN NOT NULL DEFAULT false,
    "views" INTEGER NOT NULL DEFAULT 0,
    "creator_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "released_at" TIMESTAMP(3),
    "finished_at" TIMESTAMP(3),

    CONSTRAINT "Manga_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Rating" (
    "id" SERIAL NOT NULL,
    "manga_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,

    CONSTRAINT "Rating_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Genre" (
    "id" SERIAL NOT NULL,
    "slug" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "adult" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Genre_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" SERIAL NOT NULL,
    "slug" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "adult" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_FOLLOW" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_ScanToScanUser" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_MangaToTag" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_USER_STATUS_FAVORITE" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_USER_STATUS_READING" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_USER_STATUS_READED" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_USER_STATUS_TO_READ" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_USER_STATUS_PAUSED" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_USER_STATUS_DROPED" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_USER_MANGA_EDITED" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_SCAN_CHAPTERS" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_SCAN_ALLOWED" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_GenreToManga" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Register_email_key" ON "Register"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Register_username_key" ON "Register"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Register_hash_key" ON "Register"("hash");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Discord_id_key" ON "Discord"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Discord_user_id_key" ON "Discord"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "Anilist_id_key" ON "Anilist"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Anilist_user_id_key" ON "Anilist"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "MyAnimeList_id_key" ON "MyAnimeList"("id");

-- CreateIndex
CREATE UNIQUE INDEX "MyAnimeList_user_id_key" ON "MyAnimeList"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "SuperFans_id_key" ON "SuperFans"("id");

-- CreateIndex
CREATE UNIQUE INDEX "SuperFans_user_id_key" ON "SuperFans"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "Scan_name_key" ON "Scan"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Genre_slug_key" ON "Genre"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_slug_key" ON "Tag"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "_FOLLOW_AB_unique" ON "_FOLLOW"("A", "B");

-- CreateIndex
CREATE INDEX "_FOLLOW_B_index" ON "_FOLLOW"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ScanToScanUser_AB_unique" ON "_ScanToScanUser"("A", "B");

-- CreateIndex
CREATE INDEX "_ScanToScanUser_B_index" ON "_ScanToScanUser"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_MangaToTag_AB_unique" ON "_MangaToTag"("A", "B");

-- CreateIndex
CREATE INDEX "_MangaToTag_B_index" ON "_MangaToTag"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_USER_STATUS_FAVORITE_AB_unique" ON "_USER_STATUS_FAVORITE"("A", "B");

-- CreateIndex
CREATE INDEX "_USER_STATUS_FAVORITE_B_index" ON "_USER_STATUS_FAVORITE"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_USER_STATUS_READING_AB_unique" ON "_USER_STATUS_READING"("A", "B");

-- CreateIndex
CREATE INDEX "_USER_STATUS_READING_B_index" ON "_USER_STATUS_READING"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_USER_STATUS_READED_AB_unique" ON "_USER_STATUS_READED"("A", "B");

-- CreateIndex
CREATE INDEX "_USER_STATUS_READED_B_index" ON "_USER_STATUS_READED"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_USER_STATUS_TO_READ_AB_unique" ON "_USER_STATUS_TO_READ"("A", "B");

-- CreateIndex
CREATE INDEX "_USER_STATUS_TO_READ_B_index" ON "_USER_STATUS_TO_READ"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_USER_STATUS_PAUSED_AB_unique" ON "_USER_STATUS_PAUSED"("A", "B");

-- CreateIndex
CREATE INDEX "_USER_STATUS_PAUSED_B_index" ON "_USER_STATUS_PAUSED"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_USER_STATUS_DROPED_AB_unique" ON "_USER_STATUS_DROPED"("A", "B");

-- CreateIndex
CREATE INDEX "_USER_STATUS_DROPED_B_index" ON "_USER_STATUS_DROPED"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_USER_MANGA_EDITED_AB_unique" ON "_USER_MANGA_EDITED"("A", "B");

-- CreateIndex
CREATE INDEX "_USER_MANGA_EDITED_B_index" ON "_USER_MANGA_EDITED"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_SCAN_CHAPTERS_AB_unique" ON "_SCAN_CHAPTERS"("A", "B");

-- CreateIndex
CREATE INDEX "_SCAN_CHAPTERS_B_index" ON "_SCAN_CHAPTERS"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_SCAN_ALLOWED_AB_unique" ON "_SCAN_ALLOWED"("A", "B");

-- CreateIndex
CREATE INDEX "_SCAN_ALLOWED_B_index" ON "_SCAN_ALLOWED"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_GenreToManga_AB_unique" ON "_GenreToManga"("A", "B");

-- CreateIndex
CREATE INDEX "_GenreToManga_B_index" ON "_GenreToManga"("B");

-- AddForeignKey
ALTER TABLE "UserStats" ADD CONSTRAINT "UserStats_id_fkey" FOREIGN KEY ("id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserLists" ADD CONSTRAINT "UserLists_id_fkey" FOREIGN KEY ("id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Discord" ADD CONSTRAINT "Discord_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Anilist" ADD CONSTRAINT "Anilist_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MyAnimeList" ADD CONSTRAINT "MyAnimeList_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SuperFans" ADD CONSTRAINT "SuperFans_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanUser" ADD CONSTRAINT "ScanUser_id_fkey" FOREIGN KEY ("id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanMembers" ADD CONSTRAINT "ScanMembers_scan_id_fkey" FOREIGN KEY ("scan_id") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanMembers" ADD CONSTRAINT "ScanMembers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "ScanUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanInvites" ADD CONSTRAINT "ScanInvites_scan_id_fkey" FOREIGN KEY ("scan_id") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanInvites" ADD CONSTRAINT "ScanInvites_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "ScanUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanInvites" ADD CONSTRAINT "ScanInvites_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "ScanUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanVotes" ADD CONSTRAINT "ScanVotes_scan_id_fkey" FOREIGN KEY ("scan_id") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanVotes" ADD CONSTRAINT "ScanVotes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "ScanUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanIcon" ADD CONSTRAINT "ScanIcon_id_fkey" FOREIGN KEY ("id") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanBanner" ADD CONSTRAINT "ScanBanner_id_fkey" FOREIGN KEY ("id") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Manga" ADD CONSTRAINT "Manga_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "UserLists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rating" ADD CONSTRAINT "Rating_manga_id_fkey" FOREIGN KEY ("manga_id") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rating" ADD CONSTRAINT "Rating_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "UserStats"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_FOLLOW" ADD CONSTRAINT "_FOLLOW_A_fkey" FOREIGN KEY ("A") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_FOLLOW" ADD CONSTRAINT "_FOLLOW_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ScanToScanUser" ADD CONSTRAINT "_ScanToScanUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ScanToScanUser" ADD CONSTRAINT "_ScanToScanUser_B_fkey" FOREIGN KEY ("B") REFERENCES "ScanUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_MangaToTag" ADD CONSTRAINT "_MangaToTag_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_MangaToTag" ADD CONSTRAINT "_MangaToTag_B_fkey" FOREIGN KEY ("B") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_FAVORITE" ADD CONSTRAINT "_USER_STATUS_FAVORITE_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_FAVORITE" ADD CONSTRAINT "_USER_STATUS_FAVORITE_B_fkey" FOREIGN KEY ("B") REFERENCES "UserLists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_READING" ADD CONSTRAINT "_USER_STATUS_READING_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_READING" ADD CONSTRAINT "_USER_STATUS_READING_B_fkey" FOREIGN KEY ("B") REFERENCES "UserLists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_READED" ADD CONSTRAINT "_USER_STATUS_READED_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_READED" ADD CONSTRAINT "_USER_STATUS_READED_B_fkey" FOREIGN KEY ("B") REFERENCES "UserLists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_TO_READ" ADD CONSTRAINT "_USER_STATUS_TO_READ_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_TO_READ" ADD CONSTRAINT "_USER_STATUS_TO_READ_B_fkey" FOREIGN KEY ("B") REFERENCES "UserLists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_PAUSED" ADD CONSTRAINT "_USER_STATUS_PAUSED_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_PAUSED" ADD CONSTRAINT "_USER_STATUS_PAUSED_B_fkey" FOREIGN KEY ("B") REFERENCES "UserLists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_DROPED" ADD CONSTRAINT "_USER_STATUS_DROPED_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_STATUS_DROPED" ADD CONSTRAINT "_USER_STATUS_DROPED_B_fkey" FOREIGN KEY ("B") REFERENCES "UserLists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_MANGA_EDITED" ADD CONSTRAINT "_USER_MANGA_EDITED_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_USER_MANGA_EDITED" ADD CONSTRAINT "_USER_MANGA_EDITED_B_fkey" FOREIGN KEY ("B") REFERENCES "UserLists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SCAN_CHAPTERS" ADD CONSTRAINT "_SCAN_CHAPTERS_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SCAN_CHAPTERS" ADD CONSTRAINT "_SCAN_CHAPTERS_B_fkey" FOREIGN KEY ("B") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SCAN_ALLOWED" ADD CONSTRAINT "_SCAN_ALLOWED_A_fkey" FOREIGN KEY ("A") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_SCAN_ALLOWED" ADD CONSTRAINT "_SCAN_ALLOWED_B_fkey" FOREIGN KEY ("B") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_GenreToManga" ADD CONSTRAINT "_GenreToManga_A_fkey" FOREIGN KEY ("A") REFERENCES "Genre"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_GenreToManga" ADD CONSTRAINT "_GenreToManga_B_fkey" FOREIGN KEY ("B") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;
