/*
  Warnings:

  - You are about to drop the `ScanBanner` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ScanIcon` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `status` to the `Manga` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `Manga` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "MangaTypes" AS ENUM ('MANGA', 'MANHWA', 'MANHUA', 'NOVEL', 'ONESHOT', 'DOUJINSHI', 'OTHER');

-- CreateEnum
CREATE TYPE "MangaStatus" AS ENUM ('COMPLETE', 'ONGOING', 'HIATUS', 'ONHOLD', 'PLANNED', 'ARCHIVED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ImageTypes" AS ENUM ('MANGA_COVER', 'MANGA_BANNER', 'CHAPTER_PAGE', 'USER_AVATAR', 'USER_BANNER', 'SCAN_ICON', 'SCAN_BANNER');

-- AlterEnum
ALTER TYPE "ScanMemberType" ADD VALUE 'EX_MEMBER';

-- DropForeignKey
ALTER TABLE "ScanBanner" DROP CONSTRAINT "ScanBanner_id_fkey";

-- DropForeignKey
ALTER TABLE "ScanIcon" DROP CONSTRAINT "ScanIcon_id_fkey";

-- AlterTable
ALTER TABLE "Manga" ADD COLUMN     "status" "MangaStatus" NOT NULL,
ADD COLUMN     "type" "MangaTypes" NOT NULL;

-- DropTable
DROP TABLE "ScanBanner";

-- DropTable
DROP TABLE "ScanIcon";

-- CreateTable
CREATE TABLE "Chapters" (
    "id" SERIAL NOT NULL,
    "chapter" DECIMAL(65,30) NOT NULL,
    "volume" INTEGER NOT NULL DEFAULT 0,
    "title" TEXT,
    "views" INTEGER NOT NULL DEFAULT 0,
    "extra" BOOLEAN NOT NULL DEFAULT false,
    "manga_entity_id" INTEGER NOT NULL,
    "uploaded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "uploader_id" INTEGER NOT NULL,

    CONSTRAINT "Chapters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChapterVotes" (
    "id" SERIAL NOT NULL,
    "chapter_entity_id" INTEGER NOT NULL,
    "user_entity_id" INTEGER NOT NULL,
    "vote" "VoteTypes" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChapterVotes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Images" (
    "id" SERIAL NOT NULL,
    "b2" TEXT NOT NULL,
    "uri" TEXT NOT NULL DEFAULT '/yumu/not-found.avif',
    "v" INTEGER NOT NULL DEFAULT 0,
    "mime" TEXT NOT NULL DEFAULT 'image/avif',
    "size" INTEGER NOT NULL DEFAULT 0,
    "width" INTEGER NOT NULL DEFAULT 0,
    "height" INTEGER NOT NULL DEFAULT 0,
    "type" "ImageTypes" NOT NULL,
    "manga_entity_cover" INTEGER,
    "manga_entity_banner" INTEGER,
    "chapter_entity_page" INTEGER,
    "user_entity_avatar" INTEGER,
    "user_entity_banner" INTEGER,
    "scan_entity_icon" INTEGER,
    "scan_entity_banner" INTEGER,

    CONSTRAINT "Images_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CHAPTER_UPDATED" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_ChaptersToScan" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_ChaptersToScanMembers" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_CHAPTER_VIEWS" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Images_b2_key" ON "Images"("b2");

-- CreateIndex
CREATE UNIQUE INDEX "Images_manga_entity_cover_key" ON "Images"("manga_entity_cover");

-- CreateIndex
CREATE UNIQUE INDEX "Images_manga_entity_banner_key" ON "Images"("manga_entity_banner");

-- CreateIndex
CREATE UNIQUE INDEX "Images_user_entity_avatar_key" ON "Images"("user_entity_avatar");

-- CreateIndex
CREATE UNIQUE INDEX "Images_user_entity_banner_key" ON "Images"("user_entity_banner");

-- CreateIndex
CREATE UNIQUE INDEX "Images_scan_entity_icon_key" ON "Images"("scan_entity_icon");

-- CreateIndex
CREATE UNIQUE INDEX "Images_scan_entity_banner_key" ON "Images"("scan_entity_banner");

-- CreateIndex
CREATE INDEX "Images_id_type_manga_entity_cover_idx" ON "Images"("id", "type", "manga_entity_cover");

-- CreateIndex
CREATE INDEX "Images_id_type_manga_entity_banner_idx" ON "Images"("id", "type", "manga_entity_banner");

-- CreateIndex
CREATE INDEX "Images_id_type_chapter_entity_page_idx" ON "Images"("id", "type", "chapter_entity_page");

-- CreateIndex
CREATE INDEX "Images_id_type_user_entity_avatar_idx" ON "Images"("id", "type", "user_entity_avatar");

-- CreateIndex
CREATE INDEX "Images_id_type_user_entity_banner_idx" ON "Images"("id", "type", "user_entity_banner");

-- CreateIndex
CREATE INDEX "Images_id_type_scan_entity_icon_idx" ON "Images"("id", "type", "scan_entity_icon");

-- CreateIndex
CREATE INDEX "Images_id_type_scan_entity_banner_idx" ON "Images"("id", "type", "scan_entity_banner");

-- CreateIndex
CREATE UNIQUE INDEX "_CHAPTER_UPDATED_AB_unique" ON "_CHAPTER_UPDATED"("A", "B");

-- CreateIndex
CREATE INDEX "_CHAPTER_UPDATED_B_index" ON "_CHAPTER_UPDATED"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ChaptersToScan_AB_unique" ON "_ChaptersToScan"("A", "B");

-- CreateIndex
CREATE INDEX "_ChaptersToScan_B_index" ON "_ChaptersToScan"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ChaptersToScanMembers_AB_unique" ON "_ChaptersToScanMembers"("A", "B");

-- CreateIndex
CREATE INDEX "_ChaptersToScanMembers_B_index" ON "_ChaptersToScanMembers"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_CHAPTER_VIEWS_AB_unique" ON "_CHAPTER_VIEWS"("A", "B");

-- CreateIndex
CREATE INDEX "_CHAPTER_VIEWS_B_index" ON "_CHAPTER_VIEWS"("B");

-- AddForeignKey
ALTER TABLE "Chapters" ADD CONSTRAINT "Chapters_manga_entity_id_fkey" FOREIGN KEY ("manga_entity_id") REFERENCES "Manga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Chapters" ADD CONSTRAINT "Chapters_uploader_id_fkey" FOREIGN KEY ("uploader_id") REFERENCES "UserLists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChapterVotes" ADD CONSTRAINT "ChapterVotes_chapter_entity_id_fkey" FOREIGN KEY ("chapter_entity_id") REFERENCES "Chapters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChapterVotes" ADD CONSTRAINT "ChapterVotes_user_entity_id_fkey" FOREIGN KEY ("user_entity_id") REFERENCES "UserStats"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Images" ADD CONSTRAINT "Images_manga_entity_cover_fkey" FOREIGN KEY ("manga_entity_cover") REFERENCES "Manga"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Images" ADD CONSTRAINT "Images_manga_entity_banner_fkey" FOREIGN KEY ("manga_entity_banner") REFERENCES "Manga"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Images" ADD CONSTRAINT "Images_chapter_entity_page_fkey" FOREIGN KEY ("chapter_entity_page") REFERENCES "Chapters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Images" ADD CONSTRAINT "Images_user_entity_avatar_fkey" FOREIGN KEY ("user_entity_avatar") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Images" ADD CONSTRAINT "Images_user_entity_banner_fkey" FOREIGN KEY ("user_entity_banner") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Images" ADD CONSTRAINT "Images_scan_entity_icon_fkey" FOREIGN KEY ("scan_entity_icon") REFERENCES "Scan"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Images" ADD CONSTRAINT "Images_scan_entity_banner_fkey" FOREIGN KEY ("scan_entity_banner") REFERENCES "Scan"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CHAPTER_UPDATED" ADD CONSTRAINT "_CHAPTER_UPDATED_A_fkey" FOREIGN KEY ("A") REFERENCES "Chapters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CHAPTER_UPDATED" ADD CONSTRAINT "_CHAPTER_UPDATED_B_fkey" FOREIGN KEY ("B") REFERENCES "UserLists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChaptersToScan" ADD CONSTRAINT "_ChaptersToScan_A_fkey" FOREIGN KEY ("A") REFERENCES "Chapters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChaptersToScan" ADD CONSTRAINT "_ChaptersToScan_B_fkey" FOREIGN KEY ("B") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChaptersToScanMembers" ADD CONSTRAINT "_ChaptersToScanMembers_A_fkey" FOREIGN KEY ("A") REFERENCES "Chapters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChaptersToScanMembers" ADD CONSTRAINT "_ChaptersToScanMembers_B_fkey" FOREIGN KEY ("B") REFERENCES "ScanMembers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CHAPTER_VIEWS" ADD CONSTRAINT "_CHAPTER_VIEWS_A_fkey" FOREIGN KEY ("A") REFERENCES "Chapters"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CHAPTER_VIEWS" ADD CONSTRAINT "_CHAPTER_VIEWS_B_fkey" FOREIGN KEY ("B") REFERENCES "UserLists"("id") ON DELETE CASCADE ON UPDATE CASCADE;
